# geo_code_pin.rb

require 'sidekiq-scheduler'

class GeoCodePin
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false, queue: :geocoding

  def perform
    count = PinCode.where.not(latitude: nil, longitude: nil).count
    puts "===> remaining data: #{count}"

    pin_codes = PinCode.where(latitude: nil).order(:pin_code).first(100)

    pin_codes.each do |pc|
      geocoded = pc.geocode
      next unless geocoded

      if pc.save
        puts "saving...#{pc.pin_code}"
      end
    end
  end
end