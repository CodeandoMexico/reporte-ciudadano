# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'coveralls'
require 'sidekiq/testing/inline'

Coveralls.wear!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
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
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Devise::TestHelpers, :type => :controller

  config.include HelperMethods
  config.include MailerHelpers

  config.include SessionHelpers, type: :feature
end
OmniAuth.config.test_mode = true