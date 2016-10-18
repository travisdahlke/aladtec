require 'aladtec/schedule'
require 'aladtec/position'
require 'aladtec/member'

module Aladtec
  class Range
    attr_accessor :schedule, :position, :member, :begin, :end

    def initialize(args = {})
      @member = Member.new(args["member"])
      @position = Position.new(args["position"])
      @schedule = Schedule.new(args["schedule"])
      @begin = Time.parse(args["begin"]) if args["begin"]
      @end = Time.parse(args["end"]) if args["end"]
    end

  end
end
