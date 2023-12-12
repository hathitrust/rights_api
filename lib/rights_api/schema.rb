# frozen_string_literal: true

require "sequel"

module RightsAPI
  class Schema
  end
end
require_relative "schema/access_statements_map_schema"
require_relative "schema/access_statements_schema"
require_relative "schema/rights_schema"

# Information on the various tables and their contents.
# Used mainly to translate between the more human-readable API keys
# and their corresponding abbreviasted or SQLized counterparts.
module RightsAPI
  class Schema
    NAME_TO_TABLE = {
      access_profiles: :access_profiles,
      access_statements: :access_stmts,
      access_statements_map: :access_stmts_map,
      attributes: :attributes,
      reasons: :reasons,
      rights: :rights_current,
      rights_log: :rights_log,
      sources: :sources
    }.freeze
    private_constant :NAME_TO_TABLE

    attr_reader :table

    def self.names
      NAME_TO_TABLE.keys.sort
    end

    def self.named(name:)
      case name
      when :rights, :rights_log
        RightsSchema
      when :access_statements
        AccessStatementsSchema
      when :access_statements_map
        AccessStatementsMapSchema
      else
        Schema
      end.new(table: NAME_TO_TABLE[name])
    end

    def initialize(table:)
      @table = table.to_sym
    end

    # @param [Hash] row
    # It should be fine to modify the row in-place.
    # Add, delete, modify the row data to make it conform to
    # the expected structure, in particular:
    # - Delete fields that should not be exposed in a public API.
    # - Rename fields that derive from opaque, abbreviated, or oddball column names.
    # - Add derivative fields with foreign key URLs.
    def normalize_row(row)
      row
    end

    # Subclass note:
    # This can be an "artificial" primary key that is not actually part of
    # the MySQL schema. rights_current.htid is an artificially-named actual
    # primary key, whereas access_stmts_map does not have a primary key
    # at all so we use the concatrnation of attr + / + access_profile
    def primary_key
      :id
    end

    # Transform an API search field (param) into a query
    # that can be used in a SQL WHERE or ORDER BY.
    def query_for_field(field)
      Sequel[field.to_sym]
    end

    # For use in ORDER BY clause.
    def default_order
      query_for_field primary_key
    end
  end
end
