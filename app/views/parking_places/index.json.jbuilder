json.array!(@services) do |service|
  json.extract! service, :id, :service_name, :category, :price, :discount_price, :final_price
  json.url service_url(service, format: :json)
end
