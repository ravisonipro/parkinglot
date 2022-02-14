class Api::V1::UsersController < Api::V1::ApiController
  include ApplicationHelper
  respond_to :json
  before_action :authenticate_api_user!, except: [:user_signup, :user_signin, :login_with_social_network] 

  api :POST, "/v1/users/user_signup", "new user registration."
  param :user, Hash do
    param :email, String, :desc => "email for registration", :required => true
    param :password, String, :desc => "Password for registration", :required => true
  end
  desc "This api will create new user."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": 
        {
          eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.wy8ghMG6iEb7ZUMnCMMiLTskwPh3XGQck0PCY0HSvIs
        }
        "status": true,
        "error": []
      }
  
    IF STATUS 422:
      {
        {
          "response": [],
          "status": false,
          "error": [
            "Password cant be blank"
          ]
        }
      }
  '
  def user_signup
    user = User.new(user_params)
    if user.save
      render json: { response: {token: user.auth_token} , status: true, error: [] }
    else
      render json: { response: {} , status: false, error: user.errors.full_messages }
    end
  end

  api :POST, "/v1/users/user_signin", "user login."
  param :user, Hash do
    param :email, String, :desc => "email for login", :required => true
    param :password, String, :desc => "Password for login", :required => true
  end
  desc "This api create user session."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": {
          "email": "test@professional.com",
          "name": "test",
          "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo4fQ.XdRdqQ3gCF4LPBIQo54Mmejlom9-5R6wSzFn9eDlgKg",
        },
        "status": true,
        "error": []
      }
    IF STATUS 422:
      {
        "response": [],
        "status": false,
        "error": [
          "Invalid email or password"
        ]
      }
  '
  def user_signin
    user = User.find_by_email(user_params[:email])
    if user && user.valid_password?(user_params[:password])
      session[:user_id] = user.id
      user.update_user_auth_token
      render json: { response: user.as_json , status: true, error: [] }
    else
      render json: { response: [] , status: false, error: ["Invalid email or password"] }
    end
  end

  api :POST, "/v1/users/login_with_social_network", "user login with social network."
  param :user, Hash do
    param :email, String, :desc => "email for login", :required => true
  end
  desc "This api is for user login through social network."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": {
          "email": "test@professional.com",
          "name": "test",
          "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo4fQ.XdRdqQ3gCF4LPBIQo54Mmejlom9-5R6wSzFn9eDlgKg",
        },
        "status": true,
        "error": []
      }
    IF STATUS 422:
      {
        "response": [],
        "status": false,
        "error": [
          "Invalid email address"
        ]
      }
  '
  def login_with_social_network
    user = User.find_by_email(user_params[:email])
    if !user
      generated_password = Devise.friendly_token.first(8)
      user = User.new(email: user_params[:email], password: generated_password, user_type: "social")
      if user.save
        render json: { response: user.as_json , status: true, error: [] }
      else
        render json: { response: [], status: false, error: user.errors.full_messages }
      end
    else
      session[:user_id] = user.id
      user.update_user_auth_token
      render json: { response: user.as_json , status: true, error: [] }
    end
  end


  api :POST, "/v1/users/add_feedback", "add feedback."
  header :token, 'JWT Token to identify user.', required: true
  param :feedback, Hash do
    param :topic, String, :desc => "topic of feedback", :required => true
    param :details , String, :desc => "details of feedback", :required => true
  end
  desc "This api is for user login through social network."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": {
          "message":  "Feedback has been Submitted successfully..!"
        },
        "status": true,
        "error": []
      }
    IF STATUS 422:
      {
        "response": [],
        "status": false,
        "error": [
          "Topic cant be blank"
        ]
      }
  '
  def add_feedback
    feedback = current_api_user.feedbacks.new(feedback_params)
    if feedback.save
      UserMailer.user_feedback(feedback).deliver_now rescue nil
      render json: { response: { message: "Feedback has been Submitted successfully..!" }, status: true, error: [] }
    else
      render json: { response: [] , status: false, error: feedback.errors.full_messages }
    end
  end

  def track_ip
    fip = FetchIpService.new(params[:url])
    res = fip.track
    render json: { response: res, status: true}
    # byebug
    # http://api.ipstack.com/192.168.1.1?access_key=2b7f28a9b07abe846d809757b3e4a97a&format=1
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :auth_token, :user_type)
  end

  def feedback_params
    params.require(:feedback).permit(:user_id, :topic, :details)
  end
end





