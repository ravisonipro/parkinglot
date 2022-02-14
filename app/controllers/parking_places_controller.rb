class ParkingPlacesController < ApplicationController
  before_action :set_parking_place, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :search_result, :show]
  # GET /parking_places
  # GET /parking_places.json
  def index
    @parking_places = ParkingPlace.all
  end
  
  def my_parking_place
    @parking_places = current_user.parking_places.all
  end
  # GET /parking_places/1
  # GET /parking_places/1.json
  def show
    @parking_place = ParkingPlace.find(params[:id])
    @parking_places = ParkingPlace.where(id: params[:id])
    @markars = @parking_places.blank? ? [] : @parking_places.map{|p| p.jquery_map_data_as_json }
    if Rails.env.development?
      @api_key = "AIzaSyCUlP1HqZcwDwQ_AYXCdDIShlcebCNZV7k"
    else
      @api_key = "AIzaSyCUlP1HqZcwDwQ_AYXCdDIShlcebCNZV7k"
    end
  end

  # GET /parking_places/new
  def new
    @parking_place = current_user.parking_places.new
  end

  # GET /parking_places/1/edit
  def edit
  end

  # POST /parking_places
  # POST /parking_places.json
  def create
    @parking_place = current_user.parking_places.new(parking_place_params)
    respond_to do |format|
      if @parking_place.save
        format.html { redirect_to @parking_place, notice: 'Parking place was successfully created.' }
        format.json { render :show, status: :created, location: @parking_place }
        format.js {}
      else
        @errors = true
        format.html { render :new }
        format.json { render json: @parking_place.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PATCH/PUT /parking_places/1
  # PATCH/PUT /parking_places/1.json
  def update
    respond_to do |format|
      if @parking_place.update(parking_place_params)
        format.html { redirect_to @parking_place, notice: 'Parking place was successfully updated.' }
        format.json { render :show, status: :ok, location: @parking_place }
      else
        format.html { render :edit }
        format.json { render json: @parking_place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parking_places/1
  # DELETE /parking_places/1.json
  def destroy
    @parking_place.destroy
    respond_to do |format|
      format.html { redirect_to parking_places_url, notice: 'Parking place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search_result
    @parking_places = ParkingPlace.search(params[:query])
    @markars = @parking_places.blank? ? [] : @parking_places.map{|p| p.jquery_map_data_as_json }
  end

  private

  def set_parking_place
    @parking_place = current_user.parking_places.find(params[:id])
  end

  def parking_place_params
    params.require(:parking_place).permit(:id, :user_id, :latitude, :longitude, :street, :city, :state, :zip, :address, :owner_name, :owner_number, :avail_spaces, :total_spaces, :price, :time_start, :time_end, days_availabilities: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday])
  end
end
