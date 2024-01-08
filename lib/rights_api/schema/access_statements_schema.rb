# frozen_string_literal: true

# Schema subclass for ht_rights.access_stmts
module RightsAPI
  class AccessStatementsSchema < Schema
    # @return [Symbol]
    def self.primary_key
      :stmt_key
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
