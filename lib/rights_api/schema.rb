# frozen_string_literal: true

require "sequel"

module RightsAPI
  class Schema
  end
end

require_relative "schema/access_profiles_schema"
require_relative "schema/access_statements_map_schema"
require_relative "schema/access_statements_schema"
require_relative "schema/attributes_schema"
require_relative "schema/reasons_schema"
require_relative "schema/rights_schema"
require_relative "schema/rights_log_schema"
require_relative "schema/sources_schema"

# Information on the various tables and their contents.
# Used mainly to translate between the more human-readable API keys
# and their corresponding abbreviasted or SQLized counterparts.
module RightsAPI
  class Schema
    SCHEMA_DATA = {
      access_profiles: {table_name: :access_profiles, schema_class: AccessProfilesSchema},
      access_statements: {table_name: :access_stmts, schema_class: AccessStatementsSchema},
      access_statements_map: {table_name: :access_stmts_map, schema_class: AccessStatementsMapSchema},
      attributes: {table_name: :attributes, schema_class: AttributesSchema},
      reasons: {table_name: :reasons, schema_class: ReasonsSchema},
      rights: {table_name: :rights_current, schema_class: RightsSchema},
      rights_log: {table_name: :rights_log, schema_class: RightsLogSchema},
      sources: {table_name: :sources, schema_class: SourcesSchema}
    }.freeze

    private_constant :SCHEMA_DATA

    def self.names
      SCHEMA_DATA.keys.sort
    end

    # @param name [String, Symbol] A table name
    def self.class_for(name:)
      SCHEMA_DATA[name.to_sym][:schema_class]
    end

    # @param name [String, Symbol] A table name
    def self.table_for(name:)
      SCHEMA_DATA[name.to_sym][:table_name]
    end

    # Subclass note:
    # This can be an "artificial" primary key that is not actually part of
    # the MySQL schema. rights_current.htid is an artificially-named actual
    # primary key, whereas access_stmts_map does not have a primary key
    # at all so we use the concatrnation of attr + / + access_profile
    # @return [Symbol]
    def self.primary_key
      :id
    end

    # Transform an API search field (param) into a Sequel expression
    # that can be used in a SQL WHERE or ORDER BY.
    # @param field [String, Symbol]
    # @return [Sequel::SQL::Expression]
    def self.query_for_field(field:)
      Sequel[field.to_sym]
    end

    # For use in ORDER BY clause.
    # @return [Sequel::SQL::Expression]
    def self.default_order
      query_for_field field: primary_key
    end

    # def initialize(row:)
    #   raise "Do not instantiate Schema directly."
    # end
  end
end
