# frozen_string_literal: true

require 'twitter'

class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    session[:job_id] = FindFriendsWorker.perform_async(current_user.id) unless job_id.present?
  end

  def results
    render json: Oj.dump(friends)
  end

  def status
    render json: Oj.dump(Sidekiq::Status::get_all(job_id))
  end

  private

  def job_id
    session[:job_id]
  end

  def friends
    return unless Sidekiq::Status::complete?(job_id)

    User.where(id: Authorization.where(provider: :twitter, uid: twitter_friend_ids).map(&:user_id))
        .includes(:twitter, :mastodon)
        .reject { |user| user.mastodon.nil? }
  end

  def twitter_friend_ids
    Rails.cache.read("#{current_user.id}/twitter-friends")
  end
end
