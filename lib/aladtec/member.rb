require 'happymapper'

module Aladtec
  class Member
    include HappyMapper

    tag 'member'
    attribute :id, Integer
    element :name, String
  end
end
