class AddDaysAvailabilityToParkingPlace < ActiveRecord::Migration[5.0]
  def change
    add_column :parking_places, :days_availabilities, :text
    add_column :parking_places, :availability_status, :boolean, default: true
  end
end
