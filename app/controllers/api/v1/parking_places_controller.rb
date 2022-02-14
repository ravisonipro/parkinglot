class Api::V1::ParkingPlacesController < Api::V1::ApiController
  include ApplicationHelper
  respond_to :json
  before_action :authenticate_api_user!, except: [:get_all_parking_places, :search_parking_places] 

  api :GET, "/v1/parking_places/get_all_parking_places", "get all parking places"
  desc "This api will all parking places."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": 
        {
          "latitude": 40.7127837,
          "longitude": -74.0059413,
          "street": test street,
          "city": test city,
          "state": test state,
          "zip": test zip,
          "address": test address,
          "owner_name": test owner name,
          "owner_number": test owner number,
          "avail_spaces": test avail spaces,
          "total_spaces": test total spaces,
          "price": test price,
          "time_start": test time start,
          "time_end": test time end
        }
        "status": true,
        "error": []
      }
  
    IF STATUS 422:
      {
        {
          "response": [],
          "status": false,
          "error": [
            "parking spaces not available"
          ]
        }
      }
  '
  def get_all_parking_places
    parking_places = ParkingPlace.all
    unless parking_places.blank?
      render json: { response: parking_places.map(&:as_json) , status: true, error: [] }
    else
      render json: { response: [] , status: false, error: ["parking spaces not available"] }
    end
  end

  api :POST, "/v1/parking_places/add_parking_place", "user add parking place"
  header :token, 'JWT Token to identify user.', required: true
  param :parking_place, Hash do
    param :street, String, :desc => "street of place" , :required => true 
    param :city, String, :desc => "city of place", :required => true
    param :state, String, :desc => "state of place", :required => true
    param :zip, String, :desc => "Zip code of place", :required => true
    param :address, String, :desc => "address details", :required => true
    param :owner_name, String, :desc => "owner name", :required => true
    param :owner_number, String, :desc => "owner mobile number", :required => true
    param :avail_spaces, String, :desc => "no of avail spaces", :required => true
    param :total_spaces, String, :desc => "no of total spaces", :required => true
    param :price, String, :desc => "price of booking", :required => true
    param :time_start, String, :desc => "start time", :required => true
    param :time_end, String, :desc => "end time", :required => true
  end
  desc "This api create user session."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": {
          "latitude": 22.7081955,
          "longitude": 75.8824422,
          "street": "sapna sangita",
          "city": "test city",
          "state": "test state",
          "zip": "test zip",
          "address": "test address",
          "owner_name": "test owner",
          "owner_number": "0123456789",
          "avail_spaces": 2,
          "total_spaces": 2,
          "price": 20$,
          "time_start": "2016-11-11T12:30:00.000Z",
          "time_end": "2016-11-11T06:30:00.000Z"
        },
        "status": true,
        "error": []
      }
    IF STATUS 422:
      {
        "response": [],
        "status": false,
        "error": [
          "Street cant be blank",
          "City cant be blank",
          "State cant be blank",
          "Zip cant be blank",
          "Address cant be blank"
        ]
      }
  '
  def add_parking_place
    parking_place = current_api_user.parking_places.new(parking_place_params)
    if parking_place.save
      render json: { response: parking_place.as_json , status: true, error: [] }
    else
      render json: { response: [] , status: false, error: parking_place.errors.full_messages }
    end
  end

  api :POST, "/v1/parking_places/update_parking_place_details", "update existing parking place details"
  header :token, 'JWT Token to identify user.', required: true
  param :parking_place, Hash do
    param :street, String, :desc => "street of place" , :required => true 
    param :city, String, :desc => "city of place", :required => true
    param :state, String, :desc => "state of place", :required => true
    param :zip, String, :desc => "Zip code of place", :required => true
    param :address, String, :desc => "address details", :required => true
    param :owner_name, String, :desc => "owner name", :required => true
    param :owner_number, String, :desc => "owner mobile number", :required => true
    param :avail_spaces, String, :desc => "no of avail spaces", :required => true
    param :total_spaces, String, :desc => "no of total spaces", :required => true
    param :price, String, :desc => "price of booking", :required => true
    param :time_start, String, :desc => "start time", :required => true
    param :time_end, String, :desc => "end time", :required => true
  end
  desc "This api create user session."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": {
          "latitude": 22.7081955,
          "longitude": 75.8824422,
          "street": "sapna sangita",
          "city": "test city",
          "state": "test state",
          "zip": "test zip",
          "address": "test address",
          "owner_name": "test owner",
          "owner_number": "0123456789",
          "avail_spaces": 2,
          "total_spaces": 2,
          "price": 20$,
          "time_start": "2016-11-11T12:30:00.000Z",
          "time_end": "2016-11-11T06:30:00.000Z"
        },
        "status": true,
        "error": []
      }
    IF STATUS 422:
      {
        "response": [],
        "status": false,
        "error": [
          "Street cant be blank",
          "City cant be blank",
          "State cant be blank",
          "Zip cant be blank",
          "Address cant be blank"
        ]
      }
    IF STATUS 500:
      {
        "response": [],
        "status": false,
        "error": [
          "Parking place not found with requested id"
        ]
      }
  '
  def update_parking_place_details
    parking_place = current_api_user.parking_places.find_by_id(parking_place_params[:id])
    unless parking_place.nil?
      if parking_place.update(parking_place_params)
        render json: { response: parking_place.as_json , status: true, error: [] }
      else
        render json: { response: [] , status: false, error: parking_place.errors.full_messages }
      end
    else
      render json: { response: [] , status: false, error: ["Parking place not found with requested id"]} 
    end
    
  end

  api :GET, "/v1/parking_places/destroy_parking_place", "destroy existing parking place"
  header :token, 'JWT Token to identify user.', required: true
  param :parking_place, Hash do
    param :id, String, :desc => "id of parking place" , :required => true 
  end
  desc "This api create user session."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": {
          "message": "Parking place destroy successfully"
        },
        "status": true,
        "error": []
      }
    IF STATUS 422:
      {
        "response": [],
        "status": false,
        "error": {
          "message": "Parking place cant be destroyed"
        }
      }
  '
  def destroy_parking_place
    parking_place = current_api_user.parking_places.find_by_id(parking_place_params[:id])
    if parking_place && parking_place.destroy
      render json: { response: { message: "Parking place destroy successfully" } , status: true, error: [] }
    else
      render json: { response: [] , status: false, error: { message: "Parking place can't be destroyed"} }
    end    
  end

  api :GET, "/v1/parking_places/search_parking_places", "search parking places"
  param :parking_place, Hash do
    param :zip, String, :desc => "zip code", :required => true 
    param :time_start, String, :desc => "start time" , :required => true 
    param :time_end, String, :desc => "end time" , :required => true 
  end
  desc "This api fetch parking place details with id."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": {
          "parking_place": [
            {
              "latitude": 22.7237798,
              "longitude": 75.8866896,
              "city": "Indore",
              "state": "madhya paradesh",
              "address": "Indore Treasure Town",
              "owner_name": "vinay sharma",
              "owner_number": "0123456789",
              "avail_spaces": 4,
              "total_spaces": 5,
              "price": 20,
              "time_start": "11:20 AM",
              "time_end": "01:20 AM",
              "days_availabilities": [
                "monday",
                "tuesday",
                "wednesday"
              ]
            }
          ]
        },
        "status": true,
        "error": []
      }
    IF STATUS 422:
      {
        "response": [],
        "status": false,
        "error": {
          "message": "parking places not available"
        }
      }
  '
  def search_parking_places
    parking_places = ParkingPlace.search_parking_places_for_api(parking_place_params[:zip], parking_place_params[:time_start], parking_place_params[:time_end])
    unless parking_places.blank?
      render json: { response: { parking_place: parking_places } , status: true, error: [] }
    else
      render json: { response: [] , status: false, error: { message: "parking places not available"} }
    end 
  end


  api :GET, "/v1/parking_places/parking_place_details", "get parking place details"
  header :token, 'JWT Token to identify user.', required: true
  param :parking_place, Hash do
    param :id, String, :desc => "id of parking place" , :required => true 
  end
  desc "This api fetch parking place details with id."
  example 'Response:
    IF STATUS 200:
      Response in Body:
      {
        "response": {
          "parking_place": {
            "id": 36,
            "latitude": 22.7183761,
            "longitude": 75.8843009,
            "street": "Gita Bhawan Square, Manorama Ganj, Indore, Madhya Pradesh, India",
            "city": "Indore",
            "state": "MP",
            "zip": "452001",
            "address": "Indore Treasure Town",
            "owner_name": "vinay sharma",
            "owner_number": "0123456789",
            "avail_spaces": 4,
            "total_spaces": 5,
            "price": 20,
            "parking_time_start": "10:00 AM",
            "parking_time_end": "08:00 PM",
            "parking_days_availabilities": [
              "sunday",
              "monday",
              "tuesday",
              "wednesday"
            ]
          }
        },
        "status": true,
        "error": []
      }
    IF STATUS 422:
      {
        "response": [],
        "status": false,
        "error": {
          "message": "parking place not available"
        }
      }
  '
  def parking_place_details
    parking_place = ParkingPlace.find_by_id(parking_place_params[:id])
    if parking_place
      render json: { response: { parking_place: parking_place.as_json } , status: true, error: [] }
    else
      render json: { response: [] , status: false, error: { message: "parking place details not available"} }
    end
  end

  private
  def parking_place_params
    params.require(:parking_place).permit(:id, :user_id, :latitude, :longitude, :street, :city, :state, :zip, :address, :owner_name, :owner_number, :avail_spaces, :total_spaces, :price, :time_start, :time_end)
  end
end
