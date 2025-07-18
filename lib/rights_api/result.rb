# frozen_string_literal: true

# Rights API return structure.
# Typically initialized with the full dataset for the query,
# and then data is populated according to the requested offset and limit.
module RightsAPI
  class Result
    attr_reader :offset, :total, :start, :end, :milliseconds, :cursor, :data

    # @param offset [Integer] The offset=x URL parameter.
    # @param total [Integer] The total number of results, regardless of paging.
    def initialize(offset: 0, total: 0, milliseconds: 0.0)
      @offset = offset
      @total = total
      @milliseconds = milliseconds
      @cursor = nil
      @start = 0
      @end = 0
      @data = []
    end

    # Add a row from the Sequel query.
    # @param row [Hash] A row of data from a Sequel query
    # @return [self]
    def add!(row:)
      if @data.empty?
        @start = @offset + 1
        @end = @start
      else
        @end += 1
      end
      @data << row
      self
    end

    # @return [Boolean] are there any more results after this one?
    def more?
      @end < @total
    end

    def cursor=(arg)
      @cursor = arg unless arg.nil?
    end

    # @return [Hash<String, Object>]
    def to_h
      h = {
        "total" => @total,
        "start" => @start,
        "end" => @end,
        "milliseconds" => @milliseconds,
        "data" => @data
      }
      h["cursor"] = @cursor unless @cursor.nil?
      finalize h
    end

    private

    # Override this to add any custom fields to the default ones.
    # @return [Hash<String, Object>]
    def finalize(hash)
      hash
    end
  end
end
