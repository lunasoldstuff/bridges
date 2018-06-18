# frozen_string_literal: true

module ApplicationHelper
  def twitter?
    user_signed_in? && !current_user.twitter.nil?
  end

  def mastodon?
    user_signed_in? && !current_user.mastodon.nil?
  end

  def fa_icon(name, **options)
    classes  = (options.delete(:class) || '').split(/\s+/)
    classes += ['fa', "fa-#{name}"]
    content_tag(:i, nil, options.merge(class: classes.join(' ')))
  end
end
