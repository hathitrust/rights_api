# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.rights_current and ht_rights.rights_log
module RightsAPI
  class RightsSchema < Schema
    # Add htid field based on namespace.id
    # Keep note and user out of results for public API
    # Superclass will take care of de-abbreviating attr field
    # @param row [Hash<Symbol, Object>] A table row to modify in place
    # @return [Hash<Symbol, Object>] The row that was passed
    def normalize_row(row:)
      row[:htid] = row[:namespace] + "." + row[:id]
      row.delete :user
      row.delete :note
      super row: row
    end

    # @return [Symbol]
    def primary_key
      :htid
    end

    # @param [String, Symbol] field
    # @return [Sequel::SQL::Expression]
    def query_for_field(field:)
      return Sequel.join [:namespace, :id], "." if field.to_sym == :htid
      super field: field
    end

    # rights_current and rights_log should order by timestamp
    # @return [Sequel::SQL::Expression]
    def default_order
      :time
    end
  end
end
