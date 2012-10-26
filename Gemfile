source 'https://rubygems.org'

gem 'rails', '3.2.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'simple_form'
gem 'nested_form'
gem 'devise'
gem 'cancan'
gem 'omniauth-github'
gem 'paper_trail'

#comment body markup
gem 'redcarpet'
gem 'pygmentize'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'bootstrap-sass'

#file uploads
gem 'carrierwave'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'thin'
gem 'rake'

group :development,:test do
  gem 'heroku'
  gem 'capistrano'
  gem 'capistrano-ext'
end

group :development,:test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'rb-readline'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'rspec'
  gem 'rb-fsevent'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'capybara'
  gem 'database_cleaner'
end
