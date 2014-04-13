require 'happymapper'
require 'aladtec/position'

module Aladtec
  class Schedule
    include HappyMapper

    tag 'schedule'
    has_many :positions, Position
    element :name, String
    attribute :id, Integer
  end
end
