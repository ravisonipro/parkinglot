require 'ipstack.rb'
class Location < ApplicationRecord
  include Ipstack
end
