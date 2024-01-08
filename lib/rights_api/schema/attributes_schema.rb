# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.rights_current
module RightsAPI
  class AttributesSchema < Schema
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
