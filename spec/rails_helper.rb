# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'rspec/autorun'
require 'rspec/collection_matchers'
require 'database_cleaner'
require 'pundit/rspec'
require 'paper_trail/frameworks/rspec'
require 'simplecov'
require "refile/file_double"
SimpleCov.start 'rails'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!
#ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# RSpec::Sidekiq.configure do |config|
#   config.warn_when_jobs_not_processed_by_sidekiq = false
#   config.enable_terminal_colours = false
# end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryGirl::Syntax::Methods

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  # config.use_transactional_tests = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = "random"
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    # with.test_framework :minitest
    # with.test_framework :minitest_4
    # with.test_framework :test_unit

    # Choose one or more libraries:
    with.library :active_record
    with.library :active_model
    with.library :action_controller
    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end