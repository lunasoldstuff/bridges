# frozen_string_literal: true

class FindFriendsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(user_id)
    current_user   = User.find(user_id)
    client         = current_user.twitter_client
    all_friend_ids = []
    twitter_user   = client.user

    total twitter_user.friends_count

    begin
      client.friend_ids.each do |friend_id|
        all_friend_ids << friend_id
        at all_friend_ids.size
        sleep 1
      end
    rescue Twitter::Error::TooManyRequests => error
      sleep error.rate_limit.reset_in + 1
      retry
    end

    users = User.where(id: Authorization.where(provider: :twitter, uid: all_friend_ids).map(&:user_id))
                .includes(:twitter, :mastodon)
                .reject { |user| user.mastodon.nil? }

    unless current_user.mastodon.nil?
      users.each do |user|
        begin
          user.relative_account_id = Rails.cache.fetch("#{current_user.id}/#{current_user.mastodon.domain}/#{user.mastodon.uid}", expires_in: 1.week) do
            account, _ = current_user.mastodon_client.perform_request(:get, '/api/v1/accounts/search', q: user.mastodon.uid, resolve: 'true', limit: 1)
            next if account.nil?
            account['id']
          end
        rescue Mastodon::Error, HTTP::Error, OpenSSL::SSL::SSLError
          next
        end
      end

      set_relationships!(current_user, users)
    end

    Rails.cache.write("#{current_user.id}/friends", users.map { |u| [u.id, u.relative_account_id, u.following] })
  end

  private

  def set_relationships!(current_user, users)
    account_map = users.map { |user| [user.relative_account_id, user] }.to_h
    account_ids = users.collect { |user| user.relative_account_id }.compact
    param_str   = account_ids.map { |id| "id[]=#{id}" }.join('&')

    current_user.mastodon_client.perform_request(:get, "/api/v1/accounts/relationships?#{param_str}").each do |relationship|
      account_map[relationship['id']].following = relationship['following']
    end
  rescue Mastodon::Error, HTTP::Error, OpenSSL::SSL::SSLError
    nil
  end
end
