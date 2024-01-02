# frozen_string_literal: true

module RightsAPI
  class Result
  end
end

require_relative "result/error_result"

# Rights API return structure.
# Typically initialized with the full dataset for the query,
# and then data is populated according to the requested offset and limit.
module RightsAPI
  class Result
    attr_reader :offset, :total, :start, :end, :data

    # @param offset [Integer] The offset=x URL parameter.
    # @param total [Integer] The total number of results, regardless of paging.
    def initialize(offset: 0, total: 0)
      @offset = offset
      @total = total
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

    # @return [Hash<String, Object>]
    def to_h
      h = {
        "total" => @total,
        "start" => @start,
        "end" => @end,
        "data" => @data
      }
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
