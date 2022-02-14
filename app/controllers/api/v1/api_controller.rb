class Api::V1::ApiController < ActionController::Base
  
  require 'auth_token'
  respond_to :json

  private
  def authenticate_api_user!
    invalid_user if current_api_user.blank?
  end
  
  # This method can be used as a before filter to protect
  # any actions by ensuring the request is transmitting a
  # valid JWT.
  def jwt_token
    request.headers['token'] if request.headers['token'].present? && AuthToken.valid?(request.headers['token'])
  end

  def current_api_user
    return @user if @user.present?
    
    if jwt_token.present?
      token_value = AuthToken.decoded_token_value jwt_token
      @user = User.find_by_id token_value["user_id"]
    end
  end
  
  def invalid_user
    render json: { success: false, message: "You are not authorized to access that functionality." }, status: 401 and return
  end
  
  def invalid_details
    render json: {success: false, message: "Invalid details."}, status: 404 and return
  end
end
