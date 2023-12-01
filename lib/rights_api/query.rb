# frozen_string_literal: true

require "cgi"
require "logger"

require_relative "error"
require_relative "query_parser"
require_relative "result"
require_relative "schema"
require_relative "services"

module RightsAPI
  class Query
    attr_reader :params, :schema

    def initialize(params:, schema:)
      @params = params.is_a?(String) ? CGI.parse(params) : params
      @schema = schema
      begin
        @parser = QueryParser.new(params: @params, schema: @schema)
      rescue => e
        raise QueryParserError.new(e.message)
      end
    end

    def run
      dataset = Services[:db_connection][schema.table]
      @parser.where.each do |where|
        dataset = dataset.where(where)
      end
      result = Result.new(offset: @parser.offset, total: dataset.count)
      dataset = dataset.order(*@parser.order)
        .offset(@parser.offset)
        .limit(@parser.limit)
      dataset.each do |row|
        result.add! row: @schema.normalize_row(row)
      end
      result
    end
  end
end
