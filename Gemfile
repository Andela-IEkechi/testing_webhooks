source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta3', '< 5.1'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.x'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
#form handling
gem 'simple_form', '~>3.2'
gem 'judge-simple_form'
gem 'cocoon'
#authentication
gem 'devise', '~>4.0.0.rc2'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
#audit logging
gem 'paper_trail', '~>4.1.0'
#ui
gem 'bootstrap', '~>4.0.0.alpha3'
# tooltips require tethering in bootstrap 4
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end
#controll user access
gem 'pundit', '~>1.1.0'
#icons
gem 'font-awesome-rails'
#file attachments
gem 'carrierwave'
# gem 'mini_magick'
gem 'rmagick'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'
  gem 'rspec', '>= 3.5.0.beta2', '< 4'
  gem 'rspec-rails', '>= 3.5.0.beta2', '< 4'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'awesome_print'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'guard-rspec', '~>4.6.0', require: false
  gem 'database_cleaner'
end

group :test do
  gem 'simplecov', :require => false
  # Use Factory Girl for generating random test data
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers', '>3.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
