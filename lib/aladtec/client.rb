require 'rest-client'
require 'aladtec/member'
module Aladtec
  class Client

    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(options={})
      merged_options = Aladtec.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        public_send("#{key}=", merged_options[key])
      end
    end

    # Public: Get a list of members
    #
    def members
      response = request(:getMembers)
      Member.parse(response.body)
    end

    def auth_params
      {accid: acc_id, acckey: acc_key, cusid: cus_id}
    end
    private :auth_params

    def request(cmd, options = {})
      post_params = options.merge(cmd: cmd)
      RestClient.post(endpoint, auth_params.merge(post_params), user_agent: user_agent, accept: :xml)
    end
    private :request

  end
end
