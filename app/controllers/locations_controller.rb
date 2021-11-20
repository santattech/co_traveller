class LocationsController < ApplicationController
  def index
    @location_info = {}
    last_loc = Location.order('created_at ASC').last
    locations = Location.where("created_at > ?", 1.day.ago).order('created_at ASC')
    @location_info[:last_updated_at] = last_loc.created_at.in_time_zone('Asia/Kolkata').strftime("%d %b %Y %I:%M %p")
    @location_info[:current_loc] = [last_loc.lat, last_loc.lng]
    @location_info[:points] = locations.as_json
  end
end
