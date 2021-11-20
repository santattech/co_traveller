class Location < ApplicationRecord
  validates_presence_of :lat, :lng
  validate :prevent_same_recent_location_log

  def as_json
    {
      lat: lat.to_f,
      lng: lng.to_f
    }
  end

  def created_at_least_thirty_secs_ago?
    (Time.zone.now - created_at) > 30
  end

  def prevent_same_recent_location_log
    last_location = Location.last
    return unless last_location

    if !(last_location.created_at_least_thirty_secs_ago?)
      self.errors.add(:base, "skip this location as created just now")
      return false
    end
    
    if last_location.lat == lat && last_location.lng == lng
      #errors.add(:base, "skip this location as already logged as last")
      #return false
    end
  end
end
