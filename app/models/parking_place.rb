class ParkingPlace < ApplicationRecord
  #searchkick
  serialize :days_availabilities, Hash
  serialize :spaces_availability
  
  belongs_to :user

  validates :street, :city, :state, :zip, :address,:time_start, :time_end, presence: true
  validates :city, format: { with: /\A[a-zA-Z\s]+\z/, message: "allows alphabets only" }
  validates :state, format: { with: /\A[a-zA-Z]+\z/, message: "allows alphabets only" }
  validates :owner_name, format: { with: /\A[a-zA-Z\s]+\z/, message: "allows alphabets only" }
  validate :available_spaces_should_be_equal_or_less_total_space
  validate :end_time_should_be_greater_than_start_time

  scope :only_available_places, -> {where(availability_status: true)}

  geocoded_by :full_address
  
  after_validation :geocode,
  :if => lambda{ |obj| obj.full_address_changed? }
 
  DAYS = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
  
  before_save   :default_values
  after_create  :add_spaces_availability
  #after_commit  :reindex_parking_places

  def self.search(query)
    if query == ""
      parking_places = ParkingPlace.all    
    else
      parking_places = ParkingPlace.where(zip: query)
    end
  end

  def self.search_parking_places_for_api(zip, time_start, time_end)
    available_spaces = ParkingPlace.only_available_places
    spaces_with_zip_code = available_spaces.where(zip: zip)
    parking_places = []
    unless spaces_with_zip_code.blank?
      spaces_with_zip_code.each do |s|
        if (!s.time_start.nil? && !s.time_end.nil?) && (s.time_start.try(:strftime, "%H:%M") >= time_start) && (s.time_end.try(:strftime, "%H:%M") <= time_end)
          parking_places << s.jquery_map_data_as_json
        end
      end
    end      
    return parking_places rescue []    
  end

  def full_address
    [street, address, city, state, zip].compact.join(', ')
  end

  def full_address_changed?
    street_changed? || address_changed? || city_changed? || state_changed? || zip_changed?
  end

  def as_json(options={})
    super(:only => [:id, :latitude, :longitude, :street, :city, :state, :zip, :address, :owner_name, :owner_number, :avail_spaces, :total_spaces, :price], methods: [:parking_time_start, :parking_time_end, :parking_days_availabilities])
  end

  def parking_time_start
    time_start.strftime("%I:%M %p")
  end

  def parking_time_end
    time_end.strftime("%I:%M %p")
  end

  def parking_days_availabilities
    days_availabilities.select{|e, f| e if f == "true" }.try(:keys)
  end

  def self.parking_places_with_lat_long
    parking_places = []
    ParkingPlace.select{|e| e if (e.latitude != nil && e.longitude != nil) }.each do |place|
      parking_places << { 
        latitude: place.latitude, 
        longitude: place.longitude,
        city: place.city,
        state: place.state,
        address: place.address, 
        owner_name: place.owner_name,
        owner_number: place.owner_number,
        avail_spaces: place.avail_spaces,
        total_spaces: place.total_spaces,
        price: place.price,
        time_start: place.parking_time_start,
        time_end: place.parking_time_end,
        days_availabilities: place.parking_days_availabilities
      }
    end
    return parking_places rescue []
  end

  def jquery_map_data_as_json
    {
      latitude: self.latitude, 
      longitude: self.longitude,
      city: self.city,
      state: self.state,
      address: self.address, 
      owner_name: self.owner_name,
      owner_number: self.owner_number,
      avail_spaces: self.avail_spaces,
      total_spaces: self.total_spaces,
      price: self.price,
      time_start: self.parking_time_start,
      time_end: self.parking_time_end,
      days_availabilities: self.parking_days_availabilities
    }
  end

  def available_spaces_should_be_equal_or_less_total_space
    return unless avail_spaces and total_spaces
    errors.add(:avail_spaces, "should be equal or less than total space") unless avail_spaces <= total_spaces
  end

  def end_time_should_be_greater_than_start_time
    return unless time_start and time_end
    errors.add(:time_start, "should be equal or less than end time") unless time_start <= time_end
  end

  # def reindex_parking_places
  #   ParkingPlace.reindex
  # end

  # def self.search_results(query)
  #   query == "" ? "*" : query
  #   options = 
  #   { 
  #     where: {active: true},
  #     fields: [:city, :state, :address],
  #     operator: "or",
  #     misspellings: {distance: 2}
  #   } 
  #   result = Picture.search query, options  rescue []
  # end
  private
    def default_values
      days_availabilities["sunday"] ||= "false"
      days_availabilities["monday"] ||= "false"
      days_availabilities["tuesday"] ||= "false"
      days_availabilities["wednesday"] ||= "false"
      days_availabilities["thursday"] ||= "false"
      days_availabilities["friday"] ||= "false"
      days_availabilities["saturday"] ||= "false"
    end

    def add_spaces_availability
      spaces_availability = []
      1.upto(self.total_spaces) do |i|
        space = {
          :space_id =>  i,
          :booking_date => nil,
          :start_time => nil,
          :end_time => nil,
          :status => "available"
        }
        spaces_availability << space
      end
      self.update(spaces_availability: spaces_availability)
    end
end
