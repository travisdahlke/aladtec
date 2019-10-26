# frozen_string_literal: true

require 'dry-initializer'

module Aladtec
  # ScheduledNow
  class ScheduledNow
    extend Dry::Initializer

    option :schedule_id, as: :id
    option :positions, [] do
      option :position_id, proc(&:to_i), as: :id
      option :member_id, proc(&:to_i)
    end

    def self.new(params)
      super params.transform_keys(&:to_sym)
    end
  end
end
