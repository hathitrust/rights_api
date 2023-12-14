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

    EXPANSIONS = {
      "attr" => "attribute",
      "dscr" => "description",
      "stmt" => "statement"
    }.freeze

    private_constant :NAME_TO_TABLE, :EXPANSIONS

    attr_reader :table

    def self.names
      NAME_TO_TABLE.keys.sort
    end

    # @param name [String, Symbol] A table name
    def self.named(name:)
      case name.to_sym
      when :access_statements
        AccessStatementsSchema
      when :access_statements_map
        AccessStatementsMapSchema
      when :rights, :rights_log
        RightsSchema
      else
        Schema
      end.new(table: NAME_TO_TABLE[name])
    end

    # @param table [String, Symbol]
    def initialize(table:)
      @table = table.to_sym
    end

    # It should be fine to modify the row in-place.
    # Add, delete, modify the row data to make it conform to
    # the expected structure, in particular:
    # - Delete fields that should not be exposed in a public API.
    # - Rename fields that derive from opaque, abbreviated, or oddball column names.
    # - Add derivative fields with foreign key URLs.
    # Default implementation de-abbreviates common abbreviations.
    # @param row [Hash<Symbol, Object>] A table row to modify in place
    # @return [Hash<Symbol, Object>] The row that was passed
    def normalize_row(row:)
      row.keys.each do |key|
        EXPANSIONS.each_key do |abbrev|
          if key.match? abbrev
            new_key = key.to_s.sub(abbrev, EXPANSIONS[abbrev]).to_sym
            row[new_key] = row[key]
            row.delete key
          end
        end
      end
      row
    end

    # Subclass note:
    # This can be an "artificial" primary key that is not actually part of
    # the MySQL schema. rights_current.htid is an artificially-named actual
    # primary key, whereas access_stmts_map does not have a primary key
    # at all so we use the concatrnation of attr + / + access_profile
    # @return [Symbol]
    def primary_key
      :id
    end

    # Transform an API search field (param) into a Sequel expression
    # that can be used in a SQL WHERE or ORDER BY.
    # @param field [String, Symbol]
    # @return [Sequel::SQL::Expression]
    def query_for_field(field:)
      Sequel[field.to_sym]
    end

    # For use in ORDER BY clause.
    # @return [Sequel::SQL::Expression]
    def default_order
      query_for_field field: primary_key
    end
  end
end
