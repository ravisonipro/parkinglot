json.extract! ip_location, :id, :name, :url, :latitude, :longitude, :created_at, :updated_at
json.url ip_location_url(ip_location, format: :json)
