ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'active_support'
require 'rspec/rails'
#require 'rspec/autorun'
# Add this to load Capybara integration:
require 'capybara/rspec'
require 'capybara/rails'

require 'database_cleaner'
require 'capybara-webkit'
require 'capybara/webkit/matchers'
require 'capybara-screenshot/rspec'

require 'factory_girl_rails'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.use_transactional_fixtures = false

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    #GC.disable # disable garbage collection prior to starting a test
  end

  config.after(:each) do
    #Capybara.reset_sessions!
    DatabaseCleaner.clean
  end

  config.include(Capybara::Webkit::RspecMatchers, :type => :feature)

  #config.profile_examples = 10
  #Kernel.srand config.seed

  config.order = "random"
  Capybara.current_driver = :webkit
  config.include Capybara::DSL
end
