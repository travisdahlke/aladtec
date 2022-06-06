# frozen_string_literal: true

require 'dry-initializer'

module Aladtec
  # Position
  class Position
    extend Dry::Initializer

    option :position_id, as: :id
    option :label
    option :member_id, optional: true

    def self.new(params)
      super **params.transform_keys(&:to_sym)
    end
  end
end
