class FetchIpService
  require 'uri'
  require 'net/http'
  def initialize(url)
    @url = url
  end
  def track
    uri = URI("http://api.ipstack.com/#{@url}?access_key=2b7f28a9b07abe846d809757b3e4a97a&format=1")
    res = Net::HTTP.get_response(uri)
    res.body
  end
  def call
  end
end