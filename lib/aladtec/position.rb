require 'aladtec/member'

module Aladtec
  class Position
    attr_accessor :id, :name, :member

    def initialize(args = {})
      @id = args["id"].to_i
      @name = args["name"]
      @member = Member.new(args["member"]) if args["member"]
    end
  end
end
