# frozen_string_literal: true

require 'dry-initializer'

module Aladtec
  # Member
  class Member
    extend Dry::Initializer

    option :member_id, as: :id
    option :first_name
    option :last_name
    option :is_active
    option :custom_attributes, [] do
      option :attribute_id, as: :id
      option :value
    end

    def self.new(params)
      super **params.transform_keys(&:to_sym)
    end

    def name
      [first_name, last_name].join(' ')
    end
  end
end
