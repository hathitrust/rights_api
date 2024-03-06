# frozen_string_literal: true

require "sequel"

require_relative "error"

# Processes the Hash of URL parameters passed to the API into an
# Array of WHERE constraints, as well as LIMIT, and OFFSET values.
# ORDER BY (other than the schema default) will be handled here
# in a future iteration.
module RightsAPI
  class QueryParser
    DEFAULT_LIMIT = 1000
    DEFAULT_OFFSET = 0
    attr_reader :params, :model, :where, :order, :offset, :limit

    # @param model [Class] Sequel::Model subclass for the table being queried
    def initialize(model:)
      @model = model
      @where = []
      @order = []
      @limit = DEFAULT_LIMIT
      @offset = DEFAULT_OFFSET
    end

    def parse(params: {})
      @params = params
      params.each do |key, values|
        key = key.to_sym
        case key
        when :offset
          parse_offset(values: values)
        when :limit
          parse_limit(values: values)
        else
          parse_parameter(key: key, values: values)
        end
      end
      @order = [model.default_order] if @order.empty?
      self
    end

    private

    # Parses a general search parameter and appends the resulting Sequel
    # expression to the @where array.
    # Currently only handles primary key searches.
    # Example: a URL ending with ?id=1 results in:
    # parse_parameter(key: :id, values: [1])
    # @param key [Symbol] The search parameter
    # @param values [Array] One or more parameter values
    def parse_parameter(key:, values:)
      values.each do |value|
        @where << {model.query_for_field(field: key.to_sym) => value}
      end
    end

    # Extract a single integer that can be passed to dataset.offset.
    def parse_offset(values:)
      @offset = parse_int_value(values: values, type: "OFFSET")
    end

    # Extract a single integer that can be passed to dataset.limit.
    # @param values [Array] One or more limit values
    def parse_limit(values:)
      @limit = parse_int_value(values: values, type: "LIMIT")
    end

    # Extract integer offset= or limit= value from potentially multiple values.
    # If multiple values, use the last.
    # @param values [Array] One or more offset or limit values
    # @param type [String] "OFFSET" or "LIMIT", used only for reporting errors.
    # @return [Integer]
    def parse_int_value(values:, type:)
      value = values.last.to_i
      # Make sure the offset can make a round-trip conversion between Int and String
      # https://stackoverflow.com/a/1235891
      if value.to_s != values.last
        raise QueryParserError, "#{type} expression '#{values.last}' is not an integer (#{value.to_s.class} vs #{values.last.class})"
      end
      value
    end
  end
end
