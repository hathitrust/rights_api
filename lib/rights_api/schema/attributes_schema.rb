# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.rights_current
module RightsAPI
  class AttributesSchema < Schema
    KEY_TO_QUERY = {
      description: :dscr
    }

    PERMITTED_KEYS = %i[id type name description]

    def self.query_for_key(key:)
      raise "unknown key #{key}" unless PERMITTED_KEYS.include? key

      super key: KEY_TO_QUERY.fetch(key, key)
    end

    def initialize(row:)
      @id = row[:id]
      @type = row[:type]
      @name = row[:name]
      @dscr = row[:dscr]
    end

    def to_h
      {
        id: @id,
        type: @type,
        name: @name,
        description: @dscr
      }
    end
  end
end
