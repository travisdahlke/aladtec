module Aladtec
  module Configuration
    VALID_CONNECTION_KEYS = [:endpoint, :method, :user_agent].freeze
    VALID_OPTIONS_KEYS    = [:acc_id, :acc_key, :cus_id].freeze
    VALID_CONFIG_KEYS     = VALID_CONNECTION_KEYS + VALID_OPTIONS_KEYS

    DEFAULT_ENDPOINT    = 'https://secure.emsmanager.net/api/index.php'
    DEFAULT_METHOD      = :post
    DEFAULT_USER_AGENT  = "Aladtec API Ruby Gem #{Aladtec::VERSION}".freeze

    DEFAULT_ACC_ID       = nil
    DEFAULT_ACC_KEY      = nil
    DEFAULT_CUS_ID       = nil

    attr_accessor *VALID_CONFIG_KEYS

    def self.extended(base)
      base.reset
    end

    def reset
      self.endpoint   = DEFAULT_ENDPOINT
      self.method     = DEFAULT_METHOD
      self.user_agent = DEFAULT_USER_AGENT

      self.acc_id     = DEFAULT_ACC_ID
      self.acc_key    = DEFAULT_ACC_KEY
      self.cus_id     = DEFAULT_CUS_ID
    end

    def configure
      yield self
    end

    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, public_send(key)] }.flatten ]
    end
  end
end
