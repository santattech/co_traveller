source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# administrator framework
gem 'activeadmin', '2.13.1'
gem 'devise', '4.8.1'
gem 'jwt', '1.5.6'
gem 'fast_jsonapi', '1.5'
# gem 'jsonapi-serializer'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.0'
# Use postgresql as the database for Active Record
# gem 'pg', '>= 0.18', '< 2.0'
gem 'sqlite3', '1.6.6'
# Use Puma as the app server
gem 'puma', '3.7.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
gem 'jsbundling-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors' , '2.0.1'
gem 'dotenv', '2.7.1'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-rails'
end

gem 'secure_headers', '6.3.3'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "yard", "~> 0.9.34"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# geocoding
gem 'geocoder', '1.7.0'

gem 'sidekiq-scheduler'

group :development do
  #for cap deploy
  gem 'capistrano', '3.11.0'
  # gem 'net-ssh', '4.2.0'
  gem 'net-ssh', '7.0.1'
  gem 'capistrano3-puma', '3.1.1'#github: "seuros/capistrano-puma"
  gem 'capistrano-rails', require: false
  gem 'capistrano-rails-console', '~> 2.3', require: false
  gem 'capistrano-bundler', '1.4.0', require: false
  gem 'capistrano-rake', '0.2.0', require: false
  gem 'capistrano-rvm', '0.1.2'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
end
