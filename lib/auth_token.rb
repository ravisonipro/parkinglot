require 'jwt'

module AuthToken
  def AuthToken.issue_token payload
    #payload['exp'] = 24.hours.from_now.to_i # Set expiration to 24 hours.
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decoded_token_value token
    JWT.decode(token, Rails.application.secrets.secret_key_base).first rescue nil
  end

  def AuthToken.valid? token  
    self.decoded_token_value(token).present?
  end
end