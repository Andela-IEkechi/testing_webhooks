Conductor::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false

  config.action_controller.perform_caching = true
  # Use a different cache store in production.
  config.cache_store = :dalli_store, 'localhost', { :namespace => 'conductor', :expires_in => 1.day, :compress => true }

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

  config.action_mailer.default_url_options = { :host => 'conductor-app.com' }

  config.action_mailer.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :user_name => "mandrill@shuntyard.co.za",
    :password  => "cb7fae88-04ef-44e9-9d33-b848e302e3a2"
  }

  #set up the GH values on prod for authentication
  config.before_configuration do
    ENV['GITHUB_CLIENT_ID'] = '26f02576c0c2cca553cc'
    ENV['GITHUB_CLIENT_SECRET'] = '9c360d2b2b4e0145cc9d8a17a45474a629a7a975'
    # NOTE: the callback URL on GH side MUST BE HTTP:
    # http://conductor-app.com/users/auth/github/callback
  end

  config.checkout = {
    :encryption_key => "MjM1YWE5ZDYtNjBhNy00NDUwLWFiN2MtNmFkOGZmZjM5ZGVl",
    :url => "https://www.2checkout.com/2co/buyer/purchase",
    :checkout_account => "102629581"
  }

  #Exception notification
  config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[Conductor Exception] ",
    :sender_address => %{"Conductor Notifier" <notifier@conductor-app.com>},
    :exception_recipients => %w{support@shuntyard.co.za}
  }

end
