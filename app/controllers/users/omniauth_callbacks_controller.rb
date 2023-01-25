class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: 'Facebook')
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:error] = t(
        'devise.omniauth_callbacks.failure',
        kind: 'Facebook',
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
