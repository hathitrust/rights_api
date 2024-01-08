# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.rights_current
module RightsAPI
  class SourcesSchema < Schema
    def initialize(row:)
      @id = row[:id]
      @name = row[:name]
      @dscr = row[:dscr]
      @access_profile = row[:access_profile]
      @digitization_source = row[:digitization_source]
    end

    def to_h
      {
        id: @id,
        name: @name,
        description: @dscr,
        access_profile: @access_profile,
        digitization_source: @digitization_source
      }
    end
  end
end
