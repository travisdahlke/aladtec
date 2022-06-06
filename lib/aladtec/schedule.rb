# frozen_string_literal: true

require 'dry-initializer'

module Aladtec
  # Schedule
  class Schedule
    extend Dry::Initializer

    option :schedule_id, as: :id
    option :name
    option :positions, [] do
      option :position_id, proc(&:to_i), as: :id
      option :label
    end

    def self.new(params)
      super **params.transform_keys(&:to_sym)
    end
  end
end
