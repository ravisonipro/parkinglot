class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
     	t.integer  :user_id
      t.datetime :booking_date
			t.datetime :start_time
			t.datetime :end_time
			t.float    :price
			t.integer  :parking_place_id
			t.boolean  :booking_status, default: true
      t.timestamp
    end
  end
end
