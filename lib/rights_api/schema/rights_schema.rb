# frozen_string_literal: true

require "sequel"

# Schema subclass for ht_rights.rights_current
module RightsAPI
  class RightsSchema < Schema
    # @return [Symbol]
    def self.primary_key
      :htid
    end

    # @param [String, Symbol] field
    # @return [Sequel::SQL::Expression]
    def self.query_for_field(field:)
      return Sequel.join [:namespace, :id], "." if field.to_sym == :htid
      super field: field
    end

    # rights_current and rights_log should order by timestamp
    # @return [Sequel::SQL::Expression]
    def self.default_order
      :time
    end

    def initialize(row:)
      @namespace = row[:namespace]
      @id = row[:id]
      @attr = row[:attr]
      @reason = row[:reason]
      @source = row[:source]
      @access_profile = row[:access_profile]
      @user = row[:user]
      @time = row[:time]
      @note = row[:note]
    end

    # Add htid field based on namespace.id
    # Keep note and user out of results for public API
    def to_h
      {
        namespace: @namespace,
        id: @id,
        htid: @namespace + "." + @id,
        attribute: @attr,
        # For DEV-1008 we might test something like this
        # before implementing as a JOIN for the sake of efficiency.
        # attribute: Query.new(table_name: :attributes).run(id: @attr).data[0],
        reason: @reason,
        source: @source,
        access_profile: @access_profile,
        time: @time
      }
    end
  end
end
