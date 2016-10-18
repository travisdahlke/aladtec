module Aladtec
  class Event
    attr_accessor :title, :description, :location, :begin, :end

    def initialize(args = {})
      @title = args["title"]
      @description = args["description"]
      @location = args["location"]
      @begin = Time.parse(args["begin"]) if args["begin"]
      @end = Time.parse(args["end"]) if args["end"]
    end
  end
end
