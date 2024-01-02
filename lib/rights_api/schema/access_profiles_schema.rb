# frozen_string_literal: true

# Schema subclass for ht_rights.access_profiles
module RightsAPI
  class AccessProfilesSchema < Schema
    KEY_TO_QUERY = {
      description: :dscr
    }

    PERMITTED_KEYS = %i[id name description]

    def self.query_for_key(key:)
      raise "unknown key #{key}" unless PERMITTED_KEYS.include? key

      super key: KEY_TO_QUERY.fetch(key, key)
    end

    def initialize(row:)
      @id = row[:id]
      @name = row[:name]
      @dscr = row[:dscr]
    end

    def to_h
      {
        id: @id,
        name: @name,
        description: @dscr
      }
    end
  end
end
