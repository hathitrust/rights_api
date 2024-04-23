# frozen_string_literal: true

require "base64"
require "json"
require "sequel"

# Given a list of sort fields -- Array of symbols
# and a list of field -> value mappings (the last result)
# create a string that can be decoded into
# a WHERE list

# Tries to store just enough information so the next query can
# pick up where the current one left off.

# Relies on the search parameters being unchanged between queries,
# if they do then the results are undefined.

# To create the semi-opaque cursor value for the result set,
# creates an array containing the current offset and one value for each
# sort parameter (explicit or default).

# This may be a module and not a class
module RightsAPI
  class Cursor
    OFFSET_KEY = "off"
    LAST_ROW_KEY = "last"
    attr_reader :values, :offset

    # @param cursor_string [String] the URL parameter to decode
    # @return [Array] of the form [offset, "val1", "val2" ...]
    def self.decode(cursor_string)
      JSON.parse(Base64.urlsafe_decode64(cursor_string))
    end

    def self.encode(arg)
      Base64.urlsafe_encode64(JSON.generate(arg))
    end

    def initialize(cursor_string: nil)
      @offset = 0
      @values = []
      if cursor_string
        @values = self.class.decode cursor_string
        @offset = @values.shift
      end
    end

    # @param order [Array<RightsAPI::Order>]
    # @param rows [Sequel::Dataset]
    def encode(order:, rows:)
      data = [offset + rows.count]
      row = rows.last
      order.each do |ord|
        data << row[ord.column]
      end
      Services[:logger].info "to encode: #{data}"
      self.class.encode data
    end

    # Generate zero or one WHERE clauses that will generate a pseudo-OFFSET
    # based on ORDER BY parameters.
    # FIXME: should cursor be a required parameter? (require "*" in order to get back a
    # cursor value?)
    # TODO: Can we shorten long cursors by calculating longest common initial substring
    # based on last value in current window and first value of next?
    # ORDER BY a, b, c TRANSLATES TO
    # WHERE (a > 1)
    # OR (a = 1 AND b > 2)
    # OR (a = 1 AND b = 2 AND c > 3)
    def where(model:, order:)
      return [] if values.empty?

      # Create one OR clause for each ORDER.
      # Each OR clause is a series of AND clauses.
      # The last element of each AND clause is < or >, the others are =
      # The first AND clause has only the first ORDER parameter.
      # Each subsequent one adds one ORDER PARAMETER.
      or_clause = []
      order.count.times do |order_index|
        # Take a slice of ORDER of size order_index + 1
        and_clause = order[0, order_index + 1].each_with_index.map do |ord, i|
          # in which each element is a "col op val" string
          # and the last is an inequality
          op = if i == order_index
            ord.asc? ? ">" : "<"
          else
            "="
          end
          "#{model.table_name}.#{ord.column}#{op}'#{values[i]}'"
        end
        or_clause << "(" + and_clause.join(" AND ") + ")"
      end
      res = Sequel.lit or_clause.join(" OR ")
      [res]
    end
  end
end
