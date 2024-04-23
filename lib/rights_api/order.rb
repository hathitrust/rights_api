# frozen_string_literal: true

# A class that encapsulates the field and ASC/DESC properties of a
# single ORDER BY argument.

module RightsAPI
  class Order
    attr_reader :column
    # @param column [Symbol] the field to ORDER BY
    # @param asc [Boolean] true if ASC, false if DESC
    def initialize(column:, asc: true)
      @column = column
      @asc = asc
    end

    # @return [Boolean] is the order direction ASC?
    def asc?
      @asc
    end
  end
end
