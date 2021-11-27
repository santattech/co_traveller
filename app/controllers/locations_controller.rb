class LocationsController < ApplicationController
  before_action :admin_user_logged_in

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
end
