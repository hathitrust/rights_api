# frozen_string_literal: true

module RightsAPI
  class AccessStatement < Sequel::Model(:access_stmts)
    extend ModelExtensions

    def self.default_key
      :stmt_key
    end

    def to_h
      {
        statement_key: stmt_key,
        statement_url: stmt_url,
        statement_head: stmt_head,
        statement_text: stmt_text,
        statement_url_aux: stmt_url_aux,
        statement_icon: stmt_icon,
        statement_icon_aux: stmt_icon_aux
      }
    end
  end
end
