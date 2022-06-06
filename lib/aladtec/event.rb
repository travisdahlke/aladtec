# frozen_string_literal: true

require 'dry-initializer'

module Aladtec
  # Event
  class Event
    extend Dry::Initializer

    option :event_id, as: :id
    option :title
    option :description
    option :location
    option :start_datetime, Time.method(:parse), as: :starts_at
    option :stop_datetime, Time.method(:parse), as: :ends_at, optional: true

    def self.new(params)
      super **params.transform_keys(&:to_sym)
    end
  end
end
