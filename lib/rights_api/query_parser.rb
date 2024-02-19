# frozen_string_literal: true

require "sequel"

require_relative "error"

module RightsAPI
  class QueryParser
    DEFAULT_LIMIT = 1000
    attr_reader :params, :model, :where, :order, :offset, :limit

    # @param model [Class] Schema subclass for the table being queried
    def initialize(model:)
      @model = model
      @where = []
      @order = []
      @limit = DEFAULT_LIMIT
      @offset = 0
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
          values.each do |value|
            @where << parse_parameter(key: key, value: value)
          end
        end
      end
      @order = [model.default_order] if @order.empty?
      self
    end

    private

    def parse_parameter(key:, value:)
      {model.query_for_field(field: key.to_sym) => value}
    end

    # Raturn single integer that can be passed to #offset.
    def parse_offset(values:)
      @offset = parse_int_value(values: values, type: "OFFSET")
    end

    # Raturn single integer that can be passed to #limit.
    def parse_limit(values:)
      @limit = parse_int_value(values: values, type: "LIMIT")
    end

    # Extract integer offset= or limit= value from potentially multiple values.
    # If multiple values, use the last.
    # @param values [Array] One or more offset or limit values
    # @param type [Symbol] :offset or :limit, used only for reporting errors.
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
