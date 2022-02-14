class Space < ApplicationRecord
  serialize :slots_timing
  
  belongs_to :parking_place

  def as_json(options={})
    super(:only => [:id , :current_booking_date, :available, :slots_timing])
  end
end
