class RegistrationsController < Devise::RegistrationsController
  layout 'devise_layout'

  def new
    super
  end

  def create
    build_resource(sign_up_params.merge(role: sign_up_params["role"].to_i))
    if resource.save
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_up(resource_name, resource)
      respond_to do |format|        
        format.html {redirect_to root_path, notice: "Thank you for registration." }
      end 
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected
  
  def after_update_path_for resource
    root_url
  end

  def after_sign_up_path_for(resource)
    unless check_user_address_details
      fill_address_details_path
    else
      root_path
    end
  end

  def sign_up_params
    params.require(:user).permit(:role, :name, :email, :image, :password, :password_confirmation, :auth_token, :subscription_type, :subscription_start_date, :subscription_end_date, :subscribed)
  end

  def account_update_params
    params.require(:user).permit(:role, :name, :email, :image, :password, :password_confirmation, :auth_token, :current_password, :subscription_type, :subscription_start_date, :subscription_end_date, :subscribed)
  end
  
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
