# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env['omniauth.auth'], current_user)

    if user.persisted?
      reset_friend_finding_job!
      sign_in_and_redirect(user)
    else
      redirect_to root_path
    end
  end

  alias twitter  all
  alias mastodon all

  def failure
    redirect_to root_path
  end

  private

  def reset_friend_finding_job!
    if session[:job_id].present?
      Sidekiq::Status.cancel(session[:job_id])
      Sidekiq::Status.delete(session[:job_id])
    end

    session[:job_id] = nil
  end
end
