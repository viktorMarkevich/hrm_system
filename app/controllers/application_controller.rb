class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  layout :select_layout

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = 'У Вас недостаточно прав!'
    redirect_to :root
  end

  def select_layout
    devise_controller? ? 'authorization' : 'application'
  end

  protected

  def configure_devise_permitted_parameters
    registration_params = [:post, :last_name, :first_name, :email, :region_id, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update) {
          |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up) {
          |u| u.permit(registration_params)
      }
    end
  end

  def set_current_user
    User.current_user = current_user if current_user
  end

end
