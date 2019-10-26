# frozen_string_literal: true

require 'dry/configurable'
require 'aladtec/version'
require 'aladtec/client'

# Aladtec API Wrapper
module Aladtec
  extend Dry::Configurable

  setting :endpoint, 'https://secure.aladtec.com/example/api/'
  setting :user_agent, "Aladtec API Ruby Gem #{Aladtec::VERSION}"
  setting :client_id
  setting :client_secret
end
