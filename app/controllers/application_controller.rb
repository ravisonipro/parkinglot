class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_cache_buster
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_cache_buster
    {"Cache-Control"=>"no-cache, no-store, max-age=0, must-revalidate",
      "Pragma"=>"no-cache"
    }.each do |key,value|
      response.headers[key] = value
    end
  end

  def check_user_address_details
    (current_user && current_user.address_details_available?) ? true : false
  end

  def after_sign_in_path_for(resource)
    unless check_user_address_details
      fill_address_details_path
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

end
