class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :fill_address_details, :update_address_details]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end

  def fill_address_details
    
  end

  def update_address_details
    current_user.update(city: params[:city], state: params[:state], country: params[:country], zip_code: params[:zip_code], street: params[:street], latitude: params[:latitude], longitude: params[:longitude], password:Devise.friendly_token[0,20])
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'address details successfully updated.' }
    end
  end

  def my_profile
    
  end

  def subscription_for
    @subscription = Subscription.find_by(plan_type: params[:plan])
  end

  def make_payment
    subscription = Subscription.find_by(price: params[:price])
    if subscription.check_credit_card_is_valid?(params)[0]
      response = GATEWAY.authorize(subscription.price_in_cents, credit_card, :ip => request.ip)
      current_user.transactions.create(transaction_id: response.params["transaction_id"], amount: response.params["amount"].to_f, status: response.params["ack"])
      respond_to do |format|
        if response.success?
          current_user.update_subscription_status(subscription.id)
          format.html { redirect_to payment_status_path(success: true, subscription: subscription), notice: "Congratulation!, You paid successfully" }
        else
          format.html { redirect_to payment_status_path(success: false, errors: response.message), notice: response.message }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, :alert => subscription.check_credit_card_is_valid?(params)[1] }
      end
    end
  end

  def payment_status
    @subscription = Subscription.find_by(id: params[:subscription]) if params[:success]
    current_user.update_subscription_for_trail_plan if params[:plan] == "trail"
  end

  protected

  def credit_card
    credit_card = ActiveMerchant::Billing::CreditCard.new(:type => "Visa", :number => params[:card_number], :verification_value => params[:cvv_code], :month => params[:expiration_date], :year => params[:expiration_year], :first_name => params[:first_name], :last_name => params[:last_name] )
  end

  def user_params
    params.require(:user).permit(:subscription_type, :subscription_start_date, :subscription_end_date, :subscribed, :city, :state, :country, :street, :zip_code, :latitude, :longitude)
  end
end
