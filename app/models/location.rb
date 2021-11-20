class Location < ApplicationRecord
  validates_presence_of :lat, :lng

  def as_json
    {
      lat: lat,
      lng: lng
    }
  end
end
