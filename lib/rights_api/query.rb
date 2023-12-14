# frozen_string_literal: true

require_relative "result"
require_relative "services"

module RightsAPI
  class Query
    DEFAULT_LIMIT = 1000
    attr_reader :schema

    # @param schema [Schema] A Schema object for the table to be queried.
    def initialize(schema:)
      @schema = schema
    end

    # @param id [String] The primary value to retrieve, or nil for all rows.
    # @return [Result]
    def run(id:)
      dataset = Services[:db_connection][schema.table]
      if id
        where = {schema.query_for_field(field: schema.primary_key) => id}
        dataset = dataset.where(where)
      end
      dataset = dataset.order(schema.default_order)
        .limit(DEFAULT_LIMIT)
      result = Result.new(total: dataset.count)
      dataset.each do |row|
        result.add! row: @schema.normalize_row(row: row)
      end
      result
    end
  end
end
