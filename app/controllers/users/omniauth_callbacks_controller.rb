class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    @user = User.find_for_vkontakte_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: 'VK')
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:error] = t(
        'devise.omniauth_callbacks.failure',
        kind: 'VK',
        reason: 'authentication error'
      )

      redirect_to root_path
    end
  end

  def github
    @user = User.find_for_github_oauth(request.env['omniauth.auth'])
    if @user.present?
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: 'GitGub')
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:error] = t(
        'devise.omniauth_callbacks.failure',
        kind: 'GitGub',
        reason: 'invalid credentials'
      )

      redirect_to root_path
    end
  end
end
