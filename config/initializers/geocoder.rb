# config/initializers/geocoder.rb
Geocoder.configure(
  # street address geocoding service (default :nominatim)
  # lookup: :photon,
  lookup: :photon,

  # IP address geocoding service (default :ipinfo_io)
  # ip_lookup: :maxmind,

  # to use an API key:
  # api_key: "",

  # geocoding service request timeout, in seconds (default 3):
  timeout: 10,

  # set default units to kilometers:
  units: :km,

  # caching (see Caching section below for details):
  # warning: `cache_prefix` is deprecated, use `cache_options` instead
  # cache: Redis.new,
  # cache_options: {
  #   expiration: 1.day, # Defaults to `nil`
  #   prefix: "another_key:" # Defaults to `geocoder:`
  # }
)