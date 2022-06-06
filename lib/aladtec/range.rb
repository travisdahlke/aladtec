# frozen_string_literal: true

require 'dry-initializer'

module Aladtec
  # Range
  class Range
    extend Dry::Initializer

    option :schedule_id
    option :position_id
    option :member_id
    option :start_datetime, Time.method(:parse), as: :starts_at
    option :stop_datetime, Time.method(:parse), as: :ends_at
    option :extends_before
    option :extends_after

    def self.new(params)
      super **params.transform_keys(&:to_sym)
    end
  end
end
