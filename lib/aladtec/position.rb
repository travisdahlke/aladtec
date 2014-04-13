require 'happymapper'
require 'aladtec/member'

module Aladtec
  class Position
    include HappyMapper

    tag 'position'
    element :name, String
    attribute :id, Integer
    has_one :member, Member
  end
end
