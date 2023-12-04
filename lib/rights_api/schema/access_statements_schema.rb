# frozen_string_literal: true

# Schema subclass for ht_rights.access_stmts
module RightsAPI
  class AccessStatementsSchema < Schema
    def primary_key
      :stmt_key
    end
  end
end