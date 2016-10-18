require 'aladtec/position'

module Aladtec
  class Schedule
    attr_accessor :id, :name, :positions

    def initialize(args = {})
      @id = args["id"].to_i
      @name = args["name"]
      @positions = parse_positions(args["positions"]["position"]) if args["positions"]
    end

    private

    def parse_positions(positions)
      return [] unless positions
      return [Position.new(positions)] if positions.include? "id"
      positions.map{|p| Position.new(p)}
    end

  end
end
