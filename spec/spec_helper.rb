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

require 'capybara/poltergeist'

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

  Capybara::Webkit.configure do |config|
    config.allow_url("https://www.google.com/uds/api/visualization/1.0/1195ca6324d5ce101c2f520f3c62c843/ui+en.css")
    config.allow_url("https://www.google.com/uds/api/visualization/1.0/1195ca6324d5ce101c2f520f3c62c843/format+en,default+en,ui+en,corechart+en.I.js")
    config.allow_url("https://ajax.googleapis.com/ajax/static/modules/gviz/1.0/core/tooltip.css")
    config.allow_url("ajax.googleapis.com")
    config.allow_url("www.google.com")
  end

  #config.profile_examples = 10
  #Kernel.srand config.seed

  config.order = "random"
  Capybara.javascript_driver = :poltergeist
  #Capybara.current_driver = :webkit
  config.include Capybara::DSL
end
