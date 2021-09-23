# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../dummy/config/environment", __FILE__)
require "rspec/rails"
require "factory_girl"
require "alchemy/test_support/factories"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
end
