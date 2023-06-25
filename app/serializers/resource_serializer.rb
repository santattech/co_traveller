# Base Serializer for resource objects
class ResourceSerializer
  include FastJsonapi::ObjectSerializer
  #include ApplicationHelper
  set_key_transform :camel_lower

  # include Rails.application.routes.url_helpers does not work
  class << self
    delegate :url_for, to: :'Rails.application.routes.url_helpers'
    #delegate :distance_of_time_in_words, to: :'ActionView::Helpers::DateHelper'
  end
end
