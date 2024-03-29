# frozen_string_literal: true

module RightsAPI
  class Cache
    DEFAULT_CACHE_SIZE = 1000

    def initialize(size: DEFAULT_CACHE_SIZE)
      @size = size
      # Model name + canonicalized params MD5 in order of oldest to newest
      @keys = []
      @data = {}
    end

    def add(key:, data:)
      if @data.key?(key)
        # FIXME: inefficient O(n) bahavior when bumped to newest.
        idx = @keys.index key
        @keys.delete_at idx
      elsif @keys.length >= @size
        oldest = @keys[0]
        @keys.delete_at 0
        @data.delete oldest
      end
      @data[key] = data
      @keys.push key
    end

    def [](key)
      @data[key]
    end
  end
end
