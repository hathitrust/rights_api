# frozen_string_literal: true

require "sequel"
require_relative "services"

# Information on the various tables and their contents.
# Used mainly to translate between the more human-readable API keys
# and their corresponding abbreviasted or SQLized counterparts.
module RightsAPI
  class Schema
    # FIXME: can we make this a private constant?
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

    attr_reader :table

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

    def self.table_named(name:)
      NAME_TO_TABLE[name]
    end

    def initialize(table:)
      @table = table.to_sym
    end

    # @param [Hash] row
    # It should be fine to modify the row in-place.
    # Add, delete, modify the row data to make it conform to
    # the expect structure, in particular:
    # - Delete fields that should not be exposed in a public API.
    # - Rename fields that derive from opaque, abbreviated, or oddball column names.
    # - Add derivative fields with foreign key URLs.
    def normalize_row(row)
      row
    end

    # The keys that can be used in query parameters
    def keys
      (Services[:db_connection][@table].columns + [primary_key])
        .uniq
    end

    # Subclass note:
    # This can be an "artificial" primary key that is not actually part of
    # the MySQL schema. rights_current.htid is an artificially-named actual
    # primary key, whereas access_stmts_map does not have a primary key
    # at all so we use the concatrnation of attr + / + access_profile
    def primary_key
      :id
    end

    # Transform an API search key (param) into a key
    # that can be used in a SQL WHERE or ORDER BY.
    def transform_key(key)
      Sequel[key.to_sym]
    end

    def default_order
      transform_key primary_key
    end
  end

  class AccessStatementsSchema < Schema
    def primary_key
      :stmt_key
    end
  end

  class AccessStatementsMapSchema < Schema
    # This allows for URLs like access_statements_map/pd.google
    # in the spirit of namespace . id
    def primary_key
      :attr_access_id
    end

    def transform_key(key)
      return Sequel.join [:a_attr, :a_access_profile], "." if key.to_sym == :attr_access_id
      super key
    end
  end

  class RightsSchema < Schema
    # Add htid field based on namespace.id
    # Keep note and user out of results for public API
    def normalize_row(row)
      row[:htid] = row[:namespace] + "." + row[:id]
      row.delete :user
      row.delete :note
      row
    end

    def keys
      super + [:htid] - [:user, :note]
    end

    def primary_key
      :htid
    end

    def transform_key(key)
      return Sequel.join [:namespace, :id], "." if key.to_sym == :htid
      super key
    end

    def default_order
      :time
    end
  end
end
