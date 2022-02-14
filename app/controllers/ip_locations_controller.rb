class IpLocationsController < ApplicationController
  before_action :set_ip_location, only: %i[ show edit update destroy ]

  # GET /ip_locations or /ip_locations.json
  def index
    @ip_locations = IpLocation.all
  end

  # GET /ip_locations/1 or /ip_locations/1.json
  def show
  end

  # GET /ip_locations/new
  def new
    @ip_location = IpLocation.new
  end

  # GET /ip_locations/1/edit
  def edit
  end

  # POST /ip_locations or /ip_locations.json
  def create
    @ip_location = IpLocation.new(ip_location_params)
    service = FetchIpService.new(@url)
    @url = ip_location_params[:url]
    service = FetchIpService.new(@url)
    service.track
    api = FetchIpService.new(@url)
    resp = api.track
    value = JSON.parse(resp)
    @ip_location.latitude = value["latitude"]
    @ip_location.longitude = value["longitude"]
    respond_to do |format|
      if @ip_location.save
        format.html { redirect_to ip_location_url(@ip_location), notice: "Ip location was successfully created." }
        format.json { render :show, status: :created, location: @ip_location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ip_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ip_locations/1 or /ip_locations/1.json
  def update
    respond_to do |format|
      if @ip_location.update(ip_location_params)
        format.html { redirect_to ip_location_url(@ip_location), notice: "Ip location was successfully updated." }
        format.json { render :show, status: :ok, location: @ip_location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ip_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_locations/1 or /ip_locations/1.json
  def destroy
    @ip_location.destroy

    respond_to do |format|
      format.html { redirect_to ip_locations_url, notice: "Ip location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ip_location
      @ip_location = IpLocation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ip_location_params
      params.require(:ip_location).permit(:name, :url, :latitude, :longitude)
    end
end