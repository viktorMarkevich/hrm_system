class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true

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
      registration_params = [ :post, :last_name, :first_name, :email, :region, :password, :password_confirmation ]

      if params[:action] == 'update'
        devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(registration_params << :current_password) }
      elsif params[:action] == 'create'
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(registration_params) }
      end
    end

    def after_sign_in_path_for(resource)
      root_path
      # sign_in_url = new_user_session_url
      # if request.referer == sign_in_url
      #   super
      # else
      #   stored_location_for(resource) || request.referer || root_path
      # end
    end
end