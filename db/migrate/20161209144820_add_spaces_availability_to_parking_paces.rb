class AddSpacesAvailabilityToParkingPaces < ActiveRecord::Migration[5.0]
  def change
    add_column :parking_places, :spaces_availability, :text
  end
end
