# geo_code_pin.rb

# require 'sidekiq-scheduler'

class GeoCodePin
  # include Sidekiq::Worker
  # sidekiq_options retry: 2, dead: false, queue: :geocoding

  def perform
    #puts "===> remaining data: #{count}"

    pin_codes = PinCode.where(latitude: nil).order(:pin_code)
    x = rand(pin_codes.count)
    pc = pin_codes[x]

    #pin_codes.each do |pc|
      geocoded = pc.geocode

      unless geocoded
        pc.use_nominatim
      end

      if pc.save
        puts "saving...#{pc.pin_code}"
      end
    #end
  end
end