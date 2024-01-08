# frozen_string_literal: true

# Schema subclass for ht_rights.access_profiles
module RightsAPI
  class AccessProfilesSchema < Schema
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
