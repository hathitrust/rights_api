# frozen_string_literal: true

require "sequel"

require_relative "error"

module RightsAPI
  class QueryParser
    attr_reader :params, :where, :order, :page_size, :offset, :limit

    # params can be a Hash for a string
    def initialize(params:, schema:)
      @params = params
      @schema = schema
      @where = []
      @order = []
      @limit = 1000
      @offset = 0
      parse
    end

    private

    # The order here matters, as we want the longest operators to show up
    # first when #find is called.
    OPERATORS = %w[>= > <= < !]

    def parse
      params.each do |key, values|
        key = key.to_sym
        case key
        when :order
          parse_order values
        when :offset
          parse_offset values
        when :limit
          parse_limit values
        when *@schema.keys
          values.each do |value|
            clause = parse_query_key(key, value)
            @where << clause
          end
        else
          raise QueryParserError, "unknown query key '#{key}'"
        end
      end
      @order = [@schema.default_order] if @order.empty?
      # @where = [{1 => 1}] if @where.empty?
    end

    def parse_query_key(key, value)
      key = @schema.transform_key key
      op = OPERATORS.find { |op| value.start_with?(op) && value.length > op.length }
      if op
        value = value[op.length..]
        case op
        when "!"
          Sequel.~(key => value)
        when ">="
          key >= value
        when ">"
          key > value
        when "<="
          key <= value
        when "<"
          key < value
        else
          raise QueryParserError, "unknown operator #{op}"
        end
      else
        if (match = value.match(/\s*\[(.+?)\]\s*/))
          value = match[1].gsub(/\s+/, "").split(/\s*,\s*/)
        end
        {key => value}
      end
    end

    # Raturn Array that can be passed as params to .order
    def parse_order(values)
      values.each do |value|
        key, dir = value.split(/\s+/, 2)
        key = @schema.transform_key key.to_sym
        @order << if dir.nil? || dir.downcase == "asc"
          Sequel.asc key
        else
          Sequel.desc key
        end
      end
    end

    # Raturn single integer that can be passed to #offset.
    # If multiple values, use the last.
    def parse_offset(values)
      @offset = values.last.to_i
    end

    # Raturn single integer that can be passed to #limit.
    # If multiple values, use the last.
    def parse_limit(values)
      limit = values.last.to_i
      # Make sure the limit can make a round-trip conversion between Int and String
      # https://stackoverflow.com/a/1235891
      if limit.to_s != values.last
        raise QueryParserError, "limit expression '#{values.last}' is not an integer"
      end
      @limit = limit
    end
  end
end
