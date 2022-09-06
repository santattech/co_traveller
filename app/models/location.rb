class Location < ApplicationRecord
  validates_presence_of :lat, :lng
  validate :prevent_same_recent_location_log

  scope :with_other_info, -> { where.not(other_info: nil) } 

  def as_json
    {
      lat: lat.to_f,
      lng: lng.to_f,
      createdAt: created_at.in_time_zone('Asia/Kolkata').strftime("%H:%M")
    }
  end

  
  def self.filter_by_trip(trip_name)
    self.where("other_info->>'trip_name' = ?", trip_name)
  end

  def self.trip_duration
    secs = (self.last.created_at - self.first.created_at)
    
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)

        "#{n.to_i} #{name}" unless n.to_i==0
      end
    }.compact.reverse.join(' ')
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
    return if other_info.blank?
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

  def self.distance(loc1, loc2)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters
  
    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg
  
    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }
  
    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  
    (rm * c)/ 1000.0 # Delta in km
  end
end
