# frozen_string_literal: true

require "cgi"

require_relative "error"
require_relative "query_parser"
require_relative "result"
require_relative "services"

module RightsAPI
  class Query
    attr_reader :model, :params

    # @param model [Class] Sequel::Model subclass for the table being queried
    # @param params [Hash] CGI parameters submitted to the Sinatra frontend
    def initialize(model:, params: {})
      @model = model
      @params = params
    end

    # @return [Result]
    def run
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      dataset = model.base_dataset
      # This may raise QueryParserError
      @parser = QueryParser.new(model: @model).parse(params: @params)
      @parser.where.each do |where|
        dataset = dataset.where(where)
      end
      # Save this here because offset and limit may alter the count.
      total = dataset.count
      dataset = dataset.order(*@parser.order)
        .offset(@parser.offset)
        .limit(@parser.limit).all
      time_delta = 1000 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time)
      result = Result.new(offset: @parser.offset, total: total, milliseconds: time_delta)
      dataset.each do |row|
        result.add! row: row.to_h
      end
      result
    end
  end
end
