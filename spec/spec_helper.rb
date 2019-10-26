# frozen_string_literal: true

require 'aladtec'
require 'rspec'
require 'webmock/rspec'
require 'dry/configurable/test_interface'

module Aladtec
  enable_test_interface
end

begin
  require 'pry'
rescue LoadError
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.filter_run_when_matching :focus
end

def fixture_path
  File.expand_path('fixtures', __dir__)
end

def fixture(file)
  File.new(File.join(fixture_path, file))
end
