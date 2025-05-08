# frozen_string_literal: true

require "base64"
require "json"
require "sequel"

# Given a list of sort fields -- Array of symbols
# and a list of field -> value mappings (the last result)
# create a string that can be decoded into
# a WHERE list

# Tries to store just enough information so the next query can
# pick up where the current one left off. The Base64-encoded cursor string
# is a serialized array containing the current offset and one value for each
# sort parameter (explicit or default) used in the query.

# CURSOR LIFECYCLE
# - At the beginning of the query a Cursor is created with the "cursor" URL parameter, or
#   nil if none was supplied (indicating first page of results, i.e. no previous query).
# - Query calls `cursor.where` to create a WHERE clause based on the decoded values
#   from the previous result (in effect saying "WHERE fields > last_result")
# - Query calls `cursor.offset` for the current page of results.
# - Query calls `cursor.encode` to calculate a new offset and new last_result values
#   dictated by the current ORDER BY.

# IVAR SEMANTICS
# - `offset` the (zero-based) offset into the overall results set produced by `where`, or perhaps
#   "give me the results at offset N (by using values X Y and Z)"
# - `values` the X Y and Z from above, these are the relevant values from the previous result
#   if there was one.
# It is possibly counterintuitive that X Y and Z are NOT at offset N. Offset N is the location
# of the NEXT record.

# CAVEATS
# Relies on the search parameters being unchanged between queries,
# if they do change then the results are undefined.
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

    # JSON-encode and Base64-encode an object
    # @param arg [Object] a serializable object (always an Array in this class)
    # @return [String]
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

    # Generate zero or one WHERE clauses that will generate a pseudo-OFFSET
    # based on ORDER BY parameters.
    # ORDER BY a, b, c TRANSLATES TO
    # WHERE (a > 1)
    # OR (a = 1 AND b > 2)
    # OR (a = 1 AND b = 2 AND c > 3)
    # @param model [Class] Sequel::Model subclass for the table being queried,
    #   only used for qualifying column names in the WHERE clause.
    # @param order [Array<RightsAPI::Order>] the current query's ORDER BY
    # @return [Array<Sequel::LiteralString>] zero or one Sequel literals
    def where(model:, order:)
      return [] if values.empty?

      # Create one OR clause for each ORDER.
      # Each OR clause is a series of AND clauses.
      # The last element of each AND clause is < or >, the others are =
      # The first AND clause has only the first ORDER parameter.
      # Each subsequent one adds one ORDER parameter.
      or_clause = []
      order.count.times do |order_index|
        # Take a slice of ORDER of size order_index + 1
        and_clause = order[0, order_index + 1].each_with_index.map do |ord, i|
          # in which each element is a "col op val" string and the last is an inequality
          op = if i == order_index
            ord.asc? ? ">" : "<"
          else
            "="
          end
          "#{model.table_name}.#{ord.column}#{op}'#{values[i]}'"
        end
        or_clause << "(" + and_clause.join(" AND ") + ")"
      end
      [Sequel.lit(or_clause.join(" OR "))]
    end

    # Encode the offset and the relevant values from the last result row
    # (i.e. those used in the current ORDER BY)
    # @param order [Array<RightsAPI::Order>] the current query's ORDER BY
    # @param rows [Sequel::Dataset] the result of the current query
    # @return [String]
    def encode(order:, rows:)
      data = [offset + rows.count]
      row = rows.last
      order.each do |ord|
        data << row[ord.column]
      end
      self.class.encode data
    end
  end
end
