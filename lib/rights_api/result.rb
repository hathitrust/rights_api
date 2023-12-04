# frozen_string_literal: true

# Rights API return structure.
# Typically initialized with the full dataset for the query,
# and then data is populated according to the requested offset and limit.
module RightsAPI
  class Result
    # @param [Integer] offset The offset=x URL parameter.
    # @param [Integer] total The total number of result, regardless of paging.
    def initialize(offset: 0, total: 0)
      @offset = offset
      @total = total
      @start = 0
      @end = 0
      @data = []
    end

    # @param [Hash] row A row of data from a Sequel query
    def add!(row:)
      if @data.empty?
        @start = @offset + 1
        @end = @start
      else
        @end += 1
      end
      @data << row
    end

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
    def finalize(hash)
      hash
    end
  end
end
