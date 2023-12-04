# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.access_stmts_map
module RightsAPI
  class AccessStatementsMapSchema < Schema
    # This allows for URLs like access_statements_map/pd.google
    # in the spirit of namespace . id
    def primary_key
      :attr_access_id
    end

    def query_for_field(field)
      return Sequel.join [:a_attr, :a_access_profile], "." if field.to_sym == :attr_access_id
      super field
    end
  end
end
