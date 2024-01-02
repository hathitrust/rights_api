# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.access_stmts
module RightsAPI
  class AccessStatementsSchema < Schema
    KEY_TO_QUERY = {
      statement_key: :stmt_key,
      statement_url: :stmt_url,
      statement_head: :stmt_head,
      statement_text: :stmt_text,
      statement_url_aux: :stmt_url_aux,
      statement_icon: :stmt_icon,
      statement_icon_aux: :stmt_icon_aux
    }

    PERMITTED_KEYS = %i[
      statement_key
      statement_url
      statement_head
      statement_text
      statement_url_aux
      statement_icon
      statement_icon_aux
    ]

    # @return [Symbol]
    def self.primary_key
      :statement_key
    end

    # @param key [Symbol]
    # @return [Sequel::SQL::Expression]
    def self.query_for_key(key:)
      raise "unknown key #{key}" unless PERMITTED_KEYS.include? key

      return Sequel.join [:a_attr, :a_access_profile], "." if key == :attr_access_id
      super key: KEY_TO_QUERY.fetch(key, key)
    end

    def initialize(row:)
      @stmt_key = row[:stmt_key]
      @stmt_url = row[:stmt_url]
      @stmt_head = row[:stmt_head]
      @stmt_text = row[:stmt_text]
      @stmt_url_aux = row[:stmt_url_aux]
      @stmt_icon = row[:stmt_icon]
      @stmt_icon_aux = row[:stmt_icon_aux]
    end

    def to_h
      {
        statement_key: @stmt_key,
        statement_url: @stmt_url,
        statement_head: @stmt_head,
        statement_text: @stmt_text,
        statement_url_aux: @stmt_url_aux,
        statement_icon: @stmt_icon,
        statement_icon_aux: @stmt_icon_aux
      }
    end
  end
end
