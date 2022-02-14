class CreateIpLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :ip_locations do |t|
      t.string :name
      t.string :url
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
