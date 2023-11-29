# frozen_string_literal: true

require "cgi"
require "logger"

require_relative "error"
require_relative "query_parser"
require_relative "result"
require_relative "services"

module RightsAPI
  class Query
    attr_reader :params, :table

    # Queries rights_current or rights_log based on CGI params.
    # Todo parse the query here so malformed URLs are caught in the initializer and
    # 500s are raised from #run.
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
      dataset = Services[:db_connection][@schema.table]
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
