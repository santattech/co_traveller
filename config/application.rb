require_relative "boot"

require "rails/all"
require 'dotenv'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv.load('./.env')

module CoTraveller
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.autoloader = :zeitwerk
    config.sass.preferred_syntax = :sass
    config.sass.line_comments = false
    config.sass.cache = false
    config.assets.enabled = true
    config.active_job.queue_adapter = :sidekiq
    config.active_record.belongs_to_required_by_default = false
    Dir.glob("#{config.root}/lib/*.{rb}").each { |file| require file }
    
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
