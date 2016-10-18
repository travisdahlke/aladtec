require 'aladtec'
require 'rspec'
require 'webmock/rspec'

begin
  require 'pry'
rescue LoadError
end

MultiXml.parser = :ox

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(File.join(fixture_path, file))
end
