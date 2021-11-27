class Location < ApplicationRecord
  validates_presence_of :lat, :lng
  validate :prevent_same_recent_location_log

  scope :with_other_info, -> { where.not(other_info: nil) } 

  def as_json
    {
      lat: lat.to_f,
      lng: lng.to_f
    }
  end

  
  def self.filter_by_trip(trip_name)
    self.where("other_info->>'trip_name' = ?", trip_name)
  end

  def self.calculate_distance_for_trip(trip_name)
    locations = filter_by_trip(trip_name)
    total_distance = 0

    locations.each_with_index do |location, index|
      next_location = locations[index + 1]

      if next_location
        geo_service = GeoService.new(location.lat, location.lng)
        total_distance += geo_service.calculate_distance_from(next_location.lat, next_location.lng)
      end
    end

    total_distance
  end

  def location_name
    geo_service = GeoService.new(lat, lng)
    geo_service.reverse_lookup
  end

  def self.cleanup_location
    locations = Location.all

    locations.each_with_index do |location, index|
      next if index.zero?

      prev = locations[index - 1]
      
      if prev.lat == location.lat && prev.lng == location.lng
        location.destroy
      end
    end
  end

  def created_at_least_few_secs_ago?
    (Time.zone.now - created_at) > 10
  end

  def created_before_60_seconds_ago?
    (Time.zone.now - created_at) < 15
  end

  def prevent_same_recent_location_log
    last_location = Location.last
    return unless last_location

    if !(last_location.created_at_least_few_secs_ago?)
      self.errors.add(:base, "skip this location as created just now")
      return false
    end
    
    if (last_location.lat == lat && last_location.lng == lng) && last_location.created_before_60_seconds_ago? 
      errors.add(:base, "skip this location as already logged as last")
      return false
    end
  end
end
