# frozen_string_literal: true

require "benchmark"

require_relative "error"
require_relative "query_optimizer"
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
      cached = false
      # This may raise QueryParserError
      parser.parse(params: params)
      optimizer = QueryOptimizer.new(parser: parser)
      time_delta = Benchmark.realtime do
        dataset = model.base_dataset
        parser.where.each do |where|
          dataset = dataset.where(where)
        end
        dataset = dataset.order(*parser.order)
        # Save this here because offset and limit may alter the count.
        @total = dataset.count
        optimizer.where.each do |where|
          dataset = dataset.where(where)
          cached = true
        end
        dataset = dataset.offset(optimizer.offset) if optimizer.offset.positive?
        dataset = dataset.limit(parser.limit).all
      end
      result = Result.new(offset: parser.offset, total: total, milliseconds: 1000 * time_delta,
        cached: cached)
      dataset.each do |row|
        result.add! row: row.to_h
      end
      optimizer.add_to_cache(dataset: dataset)
      result
    end
  end
end
