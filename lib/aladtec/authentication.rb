require 'happymapper'

module Aladtec
  class Authentication
    include HappyMapper

    tag 'authentication'
    attribute :code, Integer
    attribute :retry, Integer
    element :message, String
    has_one :member, Member

    def success?
      self.code == 0
    end
  end
end
