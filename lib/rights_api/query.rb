# frozen_string_literal: true

require_relative "result"
require_relative "services"

module RightsAPI
  class Query
    DEFAULT_LIMIT = 1000
    attr_reader :table_name

    # @param name [String, Symbol] The name of the table to be queried.
    def initialize(table_name:)
      @table_name = table_name
    end

    # @param id [String] The primary value to retrieve, or nil for all rows.
    # @return [Result]
    def run(id:)
      schema_class = Schema.class_for name: table_name
      dataset = Services[:db_connection][Schema.table_for name: table_name]
      if id
        where = {schema_class.query_for_field(field: schema_class.primary_key) => id}
        dataset = dataset.where(where)
      end
      dataset = dataset.order(schema_class.default_order)
        .limit(DEFAULT_LIMIT)
      result = Result.new(total: dataset.count)
      dataset.each do |row|
        schema_row = schema_class.new(row: row)
        result.add! row: schema_row.to_h
      end
      result
    end
  end
end
