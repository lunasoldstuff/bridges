# frozen_string_literal: true

class FindFriendsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(user_id)
    client         = User.find(user_id).twitter_client
    all_friend_ids = []
    twitter_user   = client.user

    total twitter_user.friends_count

    begin
      client.friend_ids.each do |friend_id|
        all_friend_ids << friend_id
        at all_friend_ids.size
      end
    rescue Twitter::Error::TooManyRequests => error
      sleep error.rate_limit.reset_in + 1
      retry
    end

    Rails.cache.write("#{user_id}/twitter-friends", all_friend_ids, expires_in: 45.minutes)
  end
end
