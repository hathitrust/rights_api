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
      dataset = model.base_dataset
      # This may raise QueryParserError
      @parser = QueryParser.new(model: @model).parse(params: @params)
      @parser.where.each do |where|
        dataset = dataset.where(where)
      end
      result = Result.new(offset: @parser.offset, total: dataset.count)
      dataset = dataset.order(*@parser.order)
        .offset(@parser.offset)
        .limit(@parser.limit).all
      dataset.each do |row|
        result.add! row: row.to_h
      end
      result
    end
  end
end
