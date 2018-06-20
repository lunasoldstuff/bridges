# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :mastodon_url, :mastodon_username, :twitter_username,
             :display_name, :avatar_url, :following

  def mastodon_url
    object.mastodon.info['url'] || object.mastodon.profile_url
  end

  def mastodon_username
    object.mastodon.uid
  end

  def twitter_username
    object.twitter.display_name
  end

  def display_name
    object.mastodon.info['display_name'].presence ||
      object.mastodon.info['username'] ||
      object.mastodon.display_name.presence ||
      object.mastodon.uid.split('@').first
  end

  def avatar_url
    object.mastodon.info['avatar'].presence
  end
end
