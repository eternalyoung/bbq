module ApplicationHelper
  def user_avatar(user)
    # TODO: Аватарка юзера, пока что заглушка
    default_avatar
  end

  def default_avatar
    asset_path('user.png')
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end
end
