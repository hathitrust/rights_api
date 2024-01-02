# frozen_string_literal: true

require "sequel"

require_relative "error"

module RightsAPI
  class QueryParser
    attr_reader :params, :schema_class, :where, :order, :page_size, :offset, :limit

    # @param params [Hash] CGI parameters of the form {"key" => ["value1", ...], ...}
    # @param schema_class [Class] Schema subclass for the table being queried
    def initialize(params:, schema_class:)
      @params = params
      @schema_class = schema_class
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
          parse_order(values: values)
        when :offset
          parse_offset(values: values)
        when :limit
          parse_limit(values: values)
        else
          values.each do |value|
            clause = parse_parameter(key: key, value: value)
            @where << clause
          end
        end
      end
      @order = [schema_class.default_order] if @order.empty?
      # @where = [{1 => 1}] if @where.empty?
    end

    def parse_parameter(key:, value:)
      query = schema_class.query_for_key(key: key.to_sym)
      op = OPERATORS.find { |op| value.start_with?(op) && value.length > op.length }
      if op
        value = value[op.length..]
        case op
        when "!"
          Sequel.~(query => value)
        when ">="
          query >= value
        when ">"
          query > value
        when "<="
          query <= value
        when "<"
          query < value
        end
      else
        if (match = value.match(/\s*\[(.+?)\]\s*/))
          value = match[1].gsub(/\s+/, "").split(/\s*,\s*/)
        end
        {query => value}
      end
    end

    # Raturn Array that can be passed as params to .order
    def parse_order(values:)
      values.each do |value|
        key, dir = value.split(/\s+/, 2)
        query = schema_class.query_for_key(key: key.to_sym)
        @order << if dir.nil? || dir.downcase == "asc"
          Sequel.asc(query)
        else
          Sequel.desc(query)
        end
      end
    end

    # Raturn single integer that can be passed to #offset.
    def parse_offset(values:)
      @offset = parse_int_value(values: values, type: :offset)
    end

    # Raturn single integer that can be passed to #limit.
    def parse_limit(values:)
      @limit = parse_int_value(values: values, type: :limit)
    end

    # Extract integer offset= or limit= value from potentially multiple values.
    # If multiple values, use the last.
    # @param values [Array] One or more offset or limit values
    # @param type [Symbol] :offset or :limit
    # @return [Integer]
    def parse_int_value(values:, type:)
      value = values.last.to_i
      # Make sure the offset can make a round-trip conversion between Int and String
      # https://stackoverflow.com/a/1235891
      if value.to_s != values.last
        raise QueryParserError, "#{type} expression '#{values.last}' is not an integer"
      end
      value
    end
  end
end
