# frozen_string_literal: true

require "benchmark"
require "cgi"

require_relative "error"
require_relative "query_parser"
require_relative "result"
require_relative "services"

module RightsAPI
  class Query
    attr_reader :model, :params, :parser, :total, :dataset

    # @param model [Class] Sequel::Model subclass for the table being queried
    # @param params [Hash] CGI parameters submitted to the Sinatra frontend
    def initialize(model:, params: {})
      @model = model
      @params = params
      @parser = QueryParser.new(model: model)
      @total = 0
      @dataset = nil
    end

    # @return [Result]
    def run
      # This may raise QueryParserError
      parser.parse(params: params)
      time_delta = Benchmark.realtime do
        @dataset = model.base_dataset
        parser.where.each do |where|
          @dataset = dataset.where(where)
        end
        # Save this here because offset and limit may alter the count.
        @total = dataset.count
        @dataset = dataset.order(*parser.order)
          .offset(parser.offset)
          .limit(parser.limit)
          .all
      end
      result = Result.new(offset: parser.offset, total: total, milliseconds: 1000 * time_delta)
      dataset.each do |row|
        result.add! row: row.to_h
      end
      result
    end
  end
end
