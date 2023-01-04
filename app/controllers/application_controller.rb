class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :config_permitted_parameters, if: :devise_controller?
  add_flash_types :info, :error, :success

  protected


  def config_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
  end



end
