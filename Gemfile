source "https://rubygems.org"

gem "rails", "~> 3.2.22" #only works with ruby 2.1.x
gem "pg"
gem "simple_form"
gem "nested_form"

gem "devise"
gem "devise_invitable"
gem 'simple_token_authentication'

gem "cancan", "1.6.9" #DO NOT USE 1.6.10 https://github.com/ryanb/cancan/issues/865
gem "omniauth-github"
gem "paper_trail"#, "~>3.0.6"
gem "rake"
gem "ruby-uuid"
gem "friendly_id"#, ">=4.0.9"

#paging
gem "kaminari"
gem "kaminari-bootstrap", '~> 0.1.3' # > 0.1.3 requires bootstrap 3

#comment body markup
gem "redcarpet"
gem "pygmentize"

gem "jquery-rails" #installs 3.1 currently which uses jQuery 1.11.1
gem "jquery-ui-rails", "5.0.1" #requires jQuery 1.11.1
gem "bootstrap-sass", "~>2.3.0"
gem 'bootstrap-tagsinput-rails'

#file uploads
gem "carrierwave"
gem "carrierwave_direct"
gem "fog"

#image manimpulation
gem "rmagick"


#production runs on this server
gem "unicorn"

gem "font-awesome-rails"

#crontab
gem "whenever"

#Send exceptions mails to support team
gem 'exception_notification'

#connect to cache
gem "dalli"

#tagging
gem 'acts-as-taggable-on'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails"#,   "~> 3.2.3"
  gem "coffee-rails"#, "~> 3.2.1"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem "therubyracer", :platforms => :ruby

  gem "uglifier"#, ">= 1.0.3"
end

group :development do
  gem "capistrano", "~>2.15"
  gem "capistrano-ext", :require => false
  gem "capistrano-recipes", :git => "https://github.com/Shuntyard/capistrano-recipes.git", :require => false
  gem "rvm-capistrano", :require => false

  gem "spring" #background server reloads for faster specs and dev
  gem "spring-commands-rspec"
  gem "guard-rspec", :require => false
end

group :development,:test do
  # gem "rspec", "~>2.14.0"
  gem "rspec-rails"#, "~>2.14.0"
  gem "shoulda-matchers", require: false
  gem "rspec-collection_matchers", require: false
  gem "rb-readline"
  gem "factory_girl_rails"
  gem "pry-rails" # for better console debugging
  #gem "pry-debugger"
  gem "pry-remote"

  gem "quiet_assets"
  gem "binding_of_caller"
  gem "thin"
end

group :test do
  gem "faker"
  gem "database_cleaner"
  gem "simplecov"
end
