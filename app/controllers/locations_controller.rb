class LocationsController < ApplicationController
  before_action :admin_user_logged_in, only: [:index]
  before_action :make_api_secure

  def index
    @location_info = {}
    locations = Location.with_other_info.order('created_at ASC')
    
    if params[:trip_name].present?
      locations = locations.filter_by_trip(params[:trip_name]) 
      @location_info[:distance] = locations.calculate_distance_for_trip(params[:trip_name]).round(2)
      @location_info[:trip_duration] = locations.trip_duration
    end
    
    last_loc = Location.order('created_at ASC').last
    
    @location_info[:last_updated_at] = last_loc.created_at.in_time_zone('Asia/Kolkata').strftime("%d %b %Y %H:%M")
    @location_info[:current_loc] = [last_loc.lat, last_loc.lng]
    @location_info[:current_loc_name] = nil
    @location_info[:points] = locations.as_json
    @location_info[:trip_names] = Location.with_other_info.pluck(:other_info).map{|t| t['trip_name']}.uniq.sort
  end

  def get_nearest_poi
    pin_codes = PinCode.near([params[:latitude].to_f, params[:longitude].to_f], 1, units: :km)
    place = ""
    
    if pin_codes.present?
      place = pin_codes.first.address
      place = "Nearest area #{place}"
    else
      pin_code = PinCode.where(latitude: params[:latitude], longitude: params[:longitude]).first_or_initialize
      pin_code.pin_code ||= "0"
      pin_code.geocode
      pin_code.save

      if !pin_code.address.present?
        pin_code.use_big_data
      end
    end

    render json: { place: place }, status: :ok
  end

  def puri_stops
    @rows = CSV.read('app/models/puri_stoppages.csv', headers: true)
    stoppages = @rows.map{|c| c['Stoppages'] }
    cnt = (stoppages.count % 3) ? (stoppages.count / 3) : (stoppages.count / 3) +1  
    @first_stoppages = stoppages[0..cnt]
    @second_stoppages = stoppages[cnt+1..(cnt+cnt)]
    @third_stoppages = stoppages[(cnt+cnt)+1..stoppages.count]

    # @rows.each do |row|
    #   unless row['loc'].present?
    #     puts "0"
    #     next
    #   end
    #   next unless row['Stoppages'] == "Chhatia"
      
    #   dest_loc_arr = row['loc'].split(',').map(&:to_f)
    #   dist = Location.distance([22.6085692,88.4382332], dest_loc_arr)
    #   puts dist
    # end
  end

  def make_api_secure

  end
end
