class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :parking_place

  scope :available_bookings, -> {where(booking_status: false)}
end
