class CreateSpaces < ActiveRecord::Migration[5.0]
  def change
    create_table :spaces do |t|
      t.integer :parking_place_id
      t.datetime :current_booking_date
      t.boolean :available, default: true
      t.text :slots_timing

      t.timestamps
    end
  end
end
