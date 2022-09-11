module LocationsHelper
  def puri_location_classes(stop)
    if stop.downcase.include?('toll')
      'alert-danger toll'
    elsif stop.downcase.include?('river')
      'alert-danger river'
    else
      'alert-danger'
    end
  end

  def approx_distance(rows, stop)
    (rows.detect{|r| r['Stoppages'] == stop }['distance'].to_f * 1.23).round(2)
  end
end
