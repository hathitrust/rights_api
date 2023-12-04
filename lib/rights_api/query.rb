# frozen_string_literal: true

require_relative "result"
require_relative "services"

module RightsAPI
  class Query
    DEFAULT_LIMIT = 1000
    attr_reader :schema

    def initialize(schema:)
      @schema = schema
    end

    def run(id:)
      dataset = Services[:db_connection][schema.table]
      if id
        where = {schema.query_for_field(schema.primary_key) => id}
        dataset = dataset.where(where)
      end
      dataset = dataset.order(schema.default_order)
        .limit(DEFAULT_LIMIT)
      result = Result.new(total: dataset.count)
      dataset.each do |row|
        result.add! row: @schema.normalize_row(row)
      end
      result
    end
  end
end
