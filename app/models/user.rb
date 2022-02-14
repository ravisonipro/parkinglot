class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  #add user role
  enum role: [:admin, :seller, :buyer]
  after_initialize :set_default_role, :if => :new_record?

  mount_uploader :image, ImageUploader

  after_create :update_user_auth_token
  
  has_many   :parking_places
  has_many   :feedbacks
  has_many   :transactions
  # belongs_to :subscription
  
  validates_exclusion_of :password, in: ->(user) { [user.email, user.name] },
                         message: 'should not be the same as your email or name'
  # validates :name, format: { with: /\A[a-zA-Z\s]+\z/, message: "allows alphabets only" }
  
  geocoded_by :full_address
  after_validation :geocode,
  :if => lambda{ |obj| obj.full_address_changed? }
 
  def full_address
    [street, city, state, country, zip_code].compact.join(', ')
  end

  def full_address_changed?
    street_changed? || city_changed? || state_changed? || country_changed? || zip_code_changed?
  end

  def address_details_available?
    (!city.nil? && !state.nil? && !country.nil? && !zip_code.nil?) ? true : false   
  end

  def as_json(options={})
    super(:only => [:auth_token, :name, :email], :methods => [:image_file_for_api])
  end

  def generate_auth_token(token)
    # token = (0...10).map{25.+(rand(20))}.join
    self.update(auth_token: token)
  end

  def update_user_auth_token
    token = AuthToken.issue_token({user_id: self.id})
    self.generate_auth_token(token)
  end

  def self.from_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create( provider:auth.provider, uid:auth.uid, email:auth.info.email, password:Devise.friendly_token[0,20])
      end    
    end
  end

  def image_url
    url = image.nil? ? "default_user.png" : image.try(:url)
    if url.nil?
      "default_user.png"
    else
      url
    end
  end

  def image_file_for_api
    image.nil? ? "https://cdn0.iconfinder.com/data/icons/avatars-6/500/Avatar_boy_man_people_account_client_male_person_user_work_sport_beard_team_glasses-512.png" : image.try(:url)
  end

  def set_default_role
    self.role ||= :buyer
  end

  def update_subscription_status(subscription_id)
    self.update(subscription_id: subscription_id, subscription_start_date: Date.today, subscription_end_date: Date.today + 29.days, subscribed: true)
  end

  def update_subscription_for_trail_plan
    self.update(subscription_id: 1, subscription_start_date: Date.today, subscription_end_date: Date.today + 14.days, subscribed: true)
  end

  def subscription_status
    subscription = self.subscription
    if subscription
      {
        subscribed: true,
        plan: subscription.plan_type,
        end_date: self.subscription_end_date
      }
    else
      {
        subscribed: false,
        plan: nil,
        end_date: nil
      }
    end
  end
end
