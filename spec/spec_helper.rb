require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'factory_girl_rails'
require 'support/factory_girl'

RSpec.configure do |config|
  config.include Capybara::DSL
end
