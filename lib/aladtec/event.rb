require 'happymapper'

module Aladtec
  class Event
    include HappyMapper

    tag 'event'
    element :title, String
    element :description, String
    element :location, String
    element :begin, Time
    element :end, Time
  end
end
