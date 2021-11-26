class GeoService
  def initialize(lat, lng)
    @lat = lat
    @lng = lng
  end

  # find the distance between two arbitrary points
  def calculate_distance_from(lat, lng)
    Geocoder::Calculations.distance_between([@lng, @lat], [lng,lat], { units: :km })
  end

  def reverse_lookup
    results = Geocoder.search([@lng, @lat])
    results.first.try(:address)
  end
end