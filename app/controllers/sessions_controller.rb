class SessionsController < Devise::SessionsController 
  layout 'devise_layout'
  skip_before_filter :verify_authenticity_token
  def new
    super
  end
   
end
