# frozen_string_literal: true

module RightsAPI
  class AccessStatementMap < Sequel::Model(:access_stmts_map)
    extend ModelExtensions
    set_primary_key [:a_attr, :a_access_profile]

    def self.default_key
      :attr_access_id
    end

    # @param [String, Symbol] field
    # @return [Sequel::SQL::Expression]
    def self.query_for_field(field:)
      return Sequel.join [:a_attr, :a_access_profile], "." if field.to_sym == :attr_access_id
      super field: field
    end

    def to_h
      {
        attribute: a_attr,
        access_profile: a_access_profile,
        statement_key: stmt_key
      }
    end
  end
end
