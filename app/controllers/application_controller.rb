class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_can_edit?

  def privacy
    render 'pages/privacy'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
  end

  def current_user_can_edit?(model)
    user_signed_in? && (
      model.user == current_user ||
      (model.try(:event).present? && model.event.user == current_user)
    )
  end

  def pundit_user
    UserContext.new(current_user, { pincode: params[:pincode], cookies: cookies })
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_class = exception.policy.class

    if policy_class == EventPolicy && exception.query == 'show?'
      flash.now[:alert] = t('.wrong_pincode') if params[:pincode].present?
      render 'password_form'
    else
      policy_name = policy_class.to_s.underscore
      flash[:alert] = t("#{policy_name}.#{exception.query}", scope: 'pundit')
      redirect_back(fallback_location: root_path)
    end
  end
end
