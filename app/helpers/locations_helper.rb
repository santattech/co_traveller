module LocationsHelper
  def puri_location_classes(stop)
    if stop.downcase.include?('toll')
      'alert-danger toll'
    else
      'alert-danger'
    end
  end
end
