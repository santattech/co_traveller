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
end
