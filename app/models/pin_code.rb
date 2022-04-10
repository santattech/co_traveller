class PinCode < ApplicationRecord
  validates_presence_of :pin_code
  geocoded_by :address

  def address
    [place, pin_code].compact.join(',')
  end

  def self.generate_data
    CSV.read('/home/in-lt-89/Downloads/IN.csv').each do |row|
      next if row[0].blank?
      next unless row[0].start_with?('7')

      p = PinCode.find_or_initialize_by(pin_code: row[0])

      p.place = "#{row[1]}, #{row[2]}"
      p.latitude = row[3]
      p.longitude = row[4]

      p.save

      if p.errors.present?
        puts "error-------------->"
        puts p.pin_code
      end
    end

    CSV.read('/home/in-lt-89/Downloads/WB.csv').each do |row|
      next if row[0].blank?
      next unless row[0].start_with?('7')

      p = PinCode.find_or_initialize_by(pin_code: row[1])

      p.place = "#{row[0]}, #{row[2]}"

      p.save

      if p.errors.present?
        puts "error-------------->"
        puts p.pin_code
      end
    end

  end

  def self.backup_csv
    file = "#{Rails.root}/db/data/pin_code.csv"
 
    table = PinCode.all;0
    
    CSV.open( file, 'w' ) do |writer|
      writer << table.first.attributes.map { |a,v| a }
      table.each do |s|
        writer << s.attributes.map { |a,v| v }
      end
    end
  end

  def self.restore_from_backup
    file = "#{Rails.root}/db/data/pin_code.csv"
    CSV.read(file).each do |row|
      next if row[1].blank?
      # next unless row[1].start_with?('7')

      p = PinCode.find_or_initialize_by(pin_code: row[1])

      p.place = "#{row[2]}"
      p.latitude = row[3]
      p.longitude = row[4]

      p.save

      if p.errors.present?
        puts "error-------------->"
        puts p.pin_code
      end
    end
  end

  def use_big_data
    return if place
    url = "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=#{self.latitude.to_f}&longitude=#{self.longitude.to_f}&localityLanguage=en"
    uri = URI url
    res = Net::HTTP.get(uri)
    address = JSON.parse(res)["locality"]
    address = address + " " + JSON.parse(res)["principalSubdivision"]
    self.place = address
    self.save
  end

  def use_nominatim
    p = place.split(' ').join('_')
    url = "https://nominatim.openstreetmap.org/search/#{place}?format=json&addressdetails=1&limit=1&polygon_svg=1"
    url = URI.encode url.strip
    uri = URI url
    res = Net::HTTP.get(uri)
    puts res
    self.latitude ||= JSON.parse(res)[0]["lat"] rescue nil
    self.longitude ||= JSON.parse(res)[0]["lon"] rescue nil
    self.save
  end
end