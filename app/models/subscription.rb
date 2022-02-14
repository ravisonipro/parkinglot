class Subscription < ApplicationRecord
  serialize :features
  has_many :users

  # def purchase
  #   response = GATEWAY.purchase(1000, credit_card, purchase_options)
  #   transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
  #   cart.update_attribute(:purchased_at, Time.now) if response.success?
  #   response.success?
  # end
  
  def price_in_cents
    (price*100).round
  end
 
  def check_credit_card_is_valid?(params = {})
    credit_card = ActiveMerchant::Billing::CreditCard.new(:type => "Visa", :number => params[:card_number], :verification_value => params[:cvv_code], :month => params[:expiration_date], :year => params[:expiration_year], :first_name => params[:first_name], :last_name => params[:last_name] )
    unless credit_card.valid?
      [false, credit_card.errors.full_messages]
    else
      [true, ""]
    end
  end
end
