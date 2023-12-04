# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.rights_current and ht_rights.rights_log
module RightsAPI
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

    def query_for_field(field)
      return Sequel.join [:namespace, :id], "." if field.to_sym == :htid
      super field
    end

    def default_order
      :time
    end
  end
end
