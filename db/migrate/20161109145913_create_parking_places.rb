class CreateParkingPlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :parking_places do |t|
      t.integer  :user_id
      t.float    :latitude
      t.float    :longitude
      t.string   :street
      t.string   :city
      t.string   :state
      t.string   :zip
      t.string   :address
      t.string   :owner_name
      t.string   :owner_number
      t.integer  :avail_spaces
      t.integer  :total_spaces
      t.float    :price
      t.datetime :time_start
      t.datetime :time_end

      t.timestamps
    end
  end
end
