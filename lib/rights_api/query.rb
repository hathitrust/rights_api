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
    def run(id: nil)
      model = Schema.model_for name: table_name
      dataset = model.base_dataset
      if id
        where = {model.query_for_field(field: model.default_key) => id}
        dataset = dataset.where(where)
      end
      dataset = dataset.order(model.default_order)
        .limit(DEFAULT_LIMIT).all
      result = Result.new(total: dataset.count)
      dataset.each do |row|
        result.add! row: row.to_h
      end
      result
    end
  end
end
