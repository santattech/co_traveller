# Base Serializer for resource objects
class ResourceSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  # include Rails.application.routes.url_helpers does not work
  class << self
    delegate :url_for, to: :'Rails.application.routes.url_helpers'
  end
end
