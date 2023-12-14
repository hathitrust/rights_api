# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.access_stmts_map
module RightsAPI
  class AccessStatementsMapSchema < Schema
    # Remove leading "a_" from "a_attr" and "a_access_profile"
    # @param row [Hash<Symbol, Object>] A table row to modify in place
    # @return [Hash<Symbol, Object>] The row that was passed
    def normalize_row(row:)
      row.keys.each do |key|
        if key.match?(/^a_/)
          new_key = key.to_s.sub(/^a_/, "").to_sym
          row[new_key] = row[key]
          row.delete key
        end
      end
      super row: row
    end

    # This allows for URLs like access_statements_map/pd.google
    # in the spirit of namespace . id
    # @return [Symbol]
    def primary_key
      :attr_access_id
    end

    # @param [String, Symbol] field
    # @return [Sequel::SQL::Expression]
    def query_for_field(field:)
      return Sequel.join [:a_attr, :a_access_profile], "." if field.to_sym == :attr_access_id
      super field: field
    end
  end
end
