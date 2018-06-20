# frozen_string_literal: true

module FriendsHelper
  def mastodon_profile_url(uid)
    username, domain = uid.split('@')
    "https://#{domain}/users/#{username}"
  end
end
