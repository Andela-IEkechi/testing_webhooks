Conductor::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.action_mailer.default_url_options = { :host => 'conductor-app-staging.herokuapp.com' }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  config.action_mailer.smtp_settings = {
    :user_name => 'conductor-staging-b88c4e57477a9aa4',
    :password => 'b97f8e3834e1897e',
    :address => 'mailtrap.io',
    :port => '2525',
    :authentication => :plain
  }

  #set up the GH values
  #we DONT HAVE TO do this on heroku, I just put the values in here for reference.
  #Heroku already has a configured set of these values on the staging server
  # config.before_configuration do
  #   ENV['GITHUB_CLIENT_ID'] = 'bd6407eded6365278e4b'
  #   ENV['GITHUB_CLIENT_SECRET'] = 'b5eb70fb4f6eee80c969435ddebe439ce45411e4'
  # end

  #set up the MyGate payment gateway values
  #we DONT HAVE TO do this on heroku, I just put the values in here for reference.
  #Heroku already has a configured set of these values on the staging server
  # config.before_configuration do
  #   ENV['MYGATE_FORM_URL'] = 'https://dev-virtual.mygateglobal.com/PaymentPage.cfm'
  #   ENV['MYGATE_APPLICATION_ID'] = '27b51bf7-e1e2-45f7-8ad8-817462ca53dd'
  #   ENV['MYGATE_MERCHANT_ID'] = '444b26e6-0b37-4215-8ea8-3c85bef5363e'
  # end
end
