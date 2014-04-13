require 'happymapper'
require 'aladtec/schedule'
require 'aladtec/position'
require 'aladtec/member'

module Aladtec
  class Range
    include HappyMapper

    tag 'range'
    has_one :schedule, Schedule
    has_one :position, Position
    has_one :member, Member
    element :begin, Time
    element :end, Time
  end
end
