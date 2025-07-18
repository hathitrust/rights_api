# frozen_string_literal: true

require_relative "order"

module RightsAPI
  module ModelExtensions
    # Overridden by classes that want to do some kind of #eager or #eager_graph
    # to take care of the joins.
    def base_dataset
      self
    end

    # Subclass note:
    # This can be an "artificial" primary key that is not actually part of
    # the MySQL schema. rights_current.htid is an artificially-named actual
    # primary key, whereas access_stmts_map does not have a primary key
    # at all so we use the concatrnation of attr + / + access_profile
    # @return [Symbol]
    def default_key
      :id
    end

    # For use in ORDER BY clause.
    # @return [Array<RightsAPI::Order>]
    def default_order
      [Order.new(column: default_key)]
    end

    # @param field [String, Symbol]
    # @return [Sequel::SQL::QualifiedIdentifier]
    def qualify(field:)
      Sequel.qualify(table_name, field.to_sym)
    end

    # Transform an API search field (param) into a Sequel expression
    # that can be used in a SQL WHERE.
    # @param field [String, Symbol]
    # @return [Sequel::SQL::QualifiedIdentifier]
    def query_for_field(field:)
      qualify(field: field)
    end
  end
end
