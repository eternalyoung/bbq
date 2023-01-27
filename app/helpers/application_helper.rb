module ApplicationHelper
  def default_avatar
    asset_path('user.png')
  end

  def user_avatar(user)
    user.avatar.attached? ? user.avatar.variant(:full) : default_avatar
  end

  def user_avatar_thumb(user)
    user.avatar.attached? ? user.avatar.variant(:thumb) : default_avatar
  end

  def event_photo(event)
    photos = event.photos.persisted

    photos.any? ? url_for(photos.sample.photo) : asset_path('event.jpg')
  end

  def event_thumb(event)
    photos = event.photos.persisted

    photos.any? ? url_for(photos.sample.photo.variant(:thumb)) : asset_path('event.jpg')
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      tag_class = options.extract!(:class)[:class]
      tag_options = {
        class: "alert alert-#{type} alert-dismissible fade show mt-3 #{tag_class}"
      }.merge(options)

      close_button = content_tag(:button, raw(""), type: "button", class: "btn-close", "data-bs-dismiss" => "alert", "aria-label" => "Close")

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg, tag_options)
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end
end
