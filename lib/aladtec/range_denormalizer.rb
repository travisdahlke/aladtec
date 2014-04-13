module Aladtec
  class RangeDenormalizer
    attr_reader :members, :schedules

    def initialize(attrs = {})
      @members = attrs.fetch(:members) { raise "You must provide the members" }
      @schedules = attrs.fetch(:schedules) { raise "You must provide the schedules" }
    end

    def denormalize(ranges)
      ranges.each do |range|
        find_member(range)
        find_schedule(range)
        find_position(range)
        range.position = positions_by_id[range.position.id] || range.position
      end
    end

    def find_member(range)
      member = members_by_id[range.member.id]
      range.member = member if member
    end

    def find_schedule(range)
      schedule = schedules_by_id[range.schedule.id]
      range.schedule = schedule if schedule
    end

    def find_position(range)
      position = positions_by_id[range.position.id]
      range.position = position if position
    end

    def members_by_id
      @members_by_id ||= members.reduce({}) {|h, member| h[member.id] = member; h}
    end

    def schedules_by_id
      @schedules_by_id ||= schedules.reduce({}) do |h, schedule|
        h[schedule.id] = schedule
        schedule.positions.each {|position| positions_by_id[position.id] ||= position}
        h
      end
    end

    def positions_by_id
      @positions_by_id ||= {}
    end
  end
end
