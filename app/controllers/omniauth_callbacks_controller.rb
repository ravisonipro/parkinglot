class OmniauthCallbacksController < Devise::OmniauthCallbacksController 
  def social_login_through_provider
    @user = User.from_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?       
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => sign_in_with_social_login) if is_navigational_format?
    else
      redirect_to new_user_registration_url, alert: "something went wrong when you try to connect with twitter...!"
    end
  end

  def sign_in_with_social_login
    if params[:action] == "google_oauth2"
      "Google"
    elsif params[:action] == "facebook"
      "Facebook"
    else
      "Twitter"
    end
      
  end

  alias_method :facebook, :social_login_through_provider
  alias_method :twitter, :social_login_through_provider
  alias_method :google_oauth2, :social_login_through_provider

end