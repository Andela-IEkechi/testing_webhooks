source 'https://rubygems.org'

gem 'rails', '~> 3.2.12'
gem 'pg'
gem 'simple_form'
gem 'nested_form'
gem 'devise', '~>3.0.3'
gem 'devise_invitable', '~> 1.1.0'

gem 'cancan', '1.6.9' #DO NOT USE 1.6.10 https://github.com/ryanb/cancan/issues/865
gem 'omniauth-github'
gem 'paper_trail'
gem 'thin'
gem 'rake'
gem 'ruby-uuid'
gem "friendly_id", ">=4.0.9"

#paging
gem 'kaminari'
gem 'kaminari-bootstrap', '~>0.1'

#comment body markup
gem 'redcarpet'
gem 'pygmentize'

gem 'jquery-rails'
gem 'jquery-ui-rails', '~>4.0.4'
gem 'bootstrap-sass', '~>2.3.2.1'

#file uploads
gem 'carrierwave'
gem 'carrierwave_direct'
gem 'fog'

#image manimpulation
gem 'rmagick'

#monitoring

#searching
gem 'ransack'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development,:test do
  gem 'heroku'
  gem 'capistrano', '~>2.15.5'
  gem 'capistrano-ext'
  gem 'capistrano-recipes', :git => 'https://github.com/Shuntyard/capistrano-recipes.git'
  gem 'rspec-rails', '~>2.14.0'
  gem 'rb-readline', '~> 0.4.2'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-rails' # for better console debugging
  #gem 'pry-debugger'
  gem 'pry-remote'
  gem 'puma'

  gem 'quiet_assets'
  gem 'binding_of_caller'
end

group :test do
  gem 'rspec', '~>2.14.0'
  gem 'database_cleaner'
end

# group :development do
#   gem 'rails-footnotes', '>= 3.7.5.rc4'
# end
