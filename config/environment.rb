# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

#allow connections from anywhere
ActionCable.server.config.disable_request_forgery_protection = true
