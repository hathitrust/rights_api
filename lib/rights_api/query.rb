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
    DEFAULT_LIMIT = 1000
    attr_reader :params, :schema_class, :table_name

    # @param params [String, Hash] CGI parameters
    # @param name [String, Symbol] The name of the table to be queried.
    def initialize(table_name:, params: {})
      @table_name = table_name
      @params = params.is_a?(String) ? CGI.parse(params) : params
      @schema_class = Schema.class_for name: table_name
      begin
        @parser = QueryParser.new(params: @params, schema_class: schema_class)
      rescue => e
        raise QueryParserError.new(e.message)
      end
    end

    def run
      dataset = Services[:db_connection][Schema.table_for name: table_name]
      @parser.where.each do |where|
        dataset = dataset.where(where)
      end
      result = Result.new(offset: @parser.offset, total: dataset.count)
      dataset = dataset.order(*@parser.order)
        .offset(@parser.offset)
        .limit(@parser.limit)
      dataset.each do |row|
        schema_row = schema_class.new(row: row)
        result.add! row: schema_row.to_h
      end
      result
    end
  end
end
