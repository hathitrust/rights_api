# frozen_string_literal: true

require "benchmark"

require_relative "cursor"
require_relative "error"
require_relative "query_parser"
require_relative "result"

module RightsAPI
  class Query
    attr_reader :model, :params, :parser, :total

    # @param model [Class] Sequel::Model subclass for the table being queried
    # @param params [Hash] CGI parameters submitted to the Sinatra frontend
    def initialize(model:, params: {})
      @model = model
      @params = params
      @parser = QueryParser.new(model: model)
      @total = 0
    end

    # @return [Result]
    def run
      dataset = nil
      # This may raise QueryParserError
      parser.parse(params: params)
      time_delta = Benchmark.realtime do
        dataset = model.base_dataset
        parser.where.each do |where|
          dataset = dataset.where(where)
        end
        dataset = dataset.order(*(parser.order.map { |order| order.to_sequel(model: model) }))
        # Save this here because limit may alter the count.
        @total = dataset.count
        dataset = dataset.limit(parser.limit).all
      end
      result = Result.new(offset: parser.cursor.offset, total: total, milliseconds: 1000 * time_delta)
      dataset.each do |row|
        result.add! row: row.to_h
      end
      if result.more?
        cursor = parser.cursor.encode(order: parser.order, rows: dataset)
        result.cursor = cursor
      end
      result
    end
  end
end
