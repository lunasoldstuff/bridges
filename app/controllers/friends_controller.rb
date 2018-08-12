# frozen_string_literal: true

require 'twitter'

class FriendsController < ApplicationController
  before_action :authenticate_user!

  MAX_INSTANCES = 20
  MIN_INSTANCES = 4

  helper_method :default_domains

  def index
    session[:job_id] = FindFriendsWorker.perform_async(current_user.id) unless job_exists?
  end

  def results
    render json: friends, each_serializer: UserSerializer
  end

  def domains
    render json: friends_domains
  end

  def status
    render json: Sidekiq::Status.get_all(job_id), serializer: StatusSerializer
  end

  def follow_all
    if Sidekiq::Status.complete?(job_id)
      loaded_friends = friends

      loaded_friends.each do |friend|
        next if friend.relative_account_id.blank? || friend.following

        begin
          relationship     = current_user.mastodon_client.perform_request(:post, "/api/v1/accounts/#{friend.relative_account_id}/follow")
          friend.following = relationship['following'] || relationship['requested']
        rescue HTTP::Error, OpenSSL::SSL::SSLError, Oj::ParseError, Mastodon::Error
          next
        end
      end

      Rails.cache.write("#{current_user.id}/friends", loaded_friends.map { |f| [f.id, f.relative_account_id, f.following] })
    end

    redirect_to friends_path
  end

  private

  def job_id
    session[:job_id]
  end

  def job_exists?
    job_id.present? && Sidekiq::Status.get_all(job_id).key?('status')
  end

  def friends
    return unless Sidekiq::Status.complete?(job_id)

    data_map = Rails.cache.fetch("#{current_user.id}/friends") { [] }.map { |d| [d.first, d] }.to_h

    return [] if data_map.empty?

    User.where(id: data_map.keys).includes(:mastodon, :twitter).map do |user|
      user.relative_account_id = data_map[user.id][1]
      user.following           = data_map[user.id][2]
      user
    end
  end

  def friends_domains
    data = Rails.cache.fetch("#{current_user.id}/friends")

    return default_domains if data.empty?

    Authorization.where(provider: 'mastodon', user_id: data.map(&:first))
                 .map(&:uid)
                 .map { |uid| uid.split('@').last }
                 .each_with_object(Hash.new(0)) { |k, h| h[k] += 1 }
                 .sort_by { |_k, v| -v }
                 .take(MAX_INSTANCES)
                 .map { |k, _| fetch_instance_info(k) }
                 .compact
  end

  def default_domains
    %w(
      octodon.social
      mastodon.art
      niu.moe
      todon.nl
      soc.ialis.me
      scifi.fyi
      hostux.social
      mstdn.maud.io
      mastodon.sdf.org
      x0r.be
      toot.cafe
    ).sample(MIN_INSTANCES).map { |k| fetch_instance_info(k) }.compact
  end

  def fetch_instance_info(host)
    Rails.cache.fetch("instance:#{host}", expires_in: 1.week) { Oj.load(HTTP.get("https://#{host}/api/v1/instance").to_s, mode: :strict) }
  rescue HTTP::Error, OpenSSL::SSL::SSLError, Oj::ParseError
    nil
  end
end
