# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.access_stmts_map
module RightsAPI
  class AccessStatementsMapSchema < Schema
    KEY_TO_QUERY = {
      attribute: :a_attr,
      access_profile: :a_access_profile
    }

    PERMITTED_KEYS = %i[id attribute access_profile statement_key]

    # This allows for URLs like access_statements_map/pd.google
    # in the spirit of namespace . id
    # @return [Symbol]
    def self.primary_key
      :id
    end

    # @param [Symbol] field
    # @return [Sequel::SQL::Expression]
    def self.query_for_key(key:)
      raise "unknown key #{key}" unless PERMITTED_KEYS.include? key

      return Sequel.join [:a_attr, :a_access_profile], "." if key == :id
      super key: KEY_TO_QUERY.fetch(key, key)
    end

    def initialize(row:)
      @a_attr = row[:a_attr]
      @a_access_profile = row[:a_access_profile]
      @stmt_key = row[:stmt_key]
    end

    def to_h
      {
        attribute: @a_attr,
        access_profile: @a_access_profile,
        statement_key: @stmt_key
      }
    end
  end
end
