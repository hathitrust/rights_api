# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.rights_current
module RightsAPI
  class ReasonsSchema < Schema
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
