ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'coveralls'
require 'sidekiq/testing/inline'

require 'factory_girl_rails'

Coveralls.wear!

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

module HelperMethods
  include I18n

  def t *args
    I18n.t(*args)
  end

  def administrative_unit
    Services.service_administrative_unit_options.last
  end

  def dependency
    Services.service_dependency_options.last
  end

  def cis
    Services.service_cis_options.last[:label]
  end

  def cis_name
    Services.service_cis.last[:name]
  end
end

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include Devise::TestHelpers, :type => :controller
  config.include HelperMethods
  config.include MailerHelpers
  config.include SessionHelpers, type: :feature
end

OmniAuth.config.test_mode = true
Capybara.default_wait_time = 10