class VisitorsController < ApplicationController

  layout :choose_layout, only: :index

  def choose_layout
    unless user_signed_in?
      "landing_page_layout"
    end
  end

  def index
    @parking_place = current_user.parking_places.new if current_user
    @parking_places = ParkingPlace.all
    @markars = ParkingPlace.parking_places_with_lat_long
    if Rails.env.development?
      @api_key = "AIzaSyCUlP1HqZcwDwQ_AYXCdDIShlcebCNZV7k"
    else
      @api_key = "AIzaSyCUlP1HqZcwDwQ_AYXCdDIShlcebCNZV7k"
    end
  end

  def get_coordinate
    coordinates = Geocoder.coordinates(params[:ip])
    respond_to do |format|
      format.json {render json: {lat: coordinates[0], long: coordinates[1]} }
    end
  end

  def parking_places_list
    @parking_places = ParkingPlace.all
  end

  def subscriptions
    
  end

  def about_us
    
  end
end
