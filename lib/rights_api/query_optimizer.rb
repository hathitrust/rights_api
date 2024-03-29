# frozen_string_literal: true

require "digest/md5"
require "json/canonicalization"

require_relative "services"

module RightsAPI
  class QueryOptimizer
    attr_reader :parser, :offset, :where

    # A class that translates parsed query and optimizes it to
    # avoid large OFFSETS into large tables when previous (cached) queries
    # may enable the use of smaller or zero OFFSET.
    # Doing this requires a model class that returns `true` for `#optimize?`
    # and implements `.optimizer_query`, the results of which are used to derive
    # additional `where` clause(s) that reduce or eliminate the OFFSET.
    #
    # This is only used with rights_current and rights_log.
    #
    # Provides a modified `#offset` that supersedes the query parser's version,
    # and `#where` clause(s) that should be applied after the parser's `#where`
    # that should replace or augment the desired OFFSET.
    def initialize(parser:)
      @parser = parser
      @where = []
      @offset = parser.offset
      optimize
    end

    def add_to_cache(dataset:)
      return if ENV["RIGHTS_API_DISABLE_OFFSET_OPTIMIZER"]
      return if dataset.count.zero?
      return unless dataset.last.class.optimize?

      data = {
        offset: parser.offset,
        limit: parser.limit,
        last: dataset.last.to_h
      }
      Services[:cache].add(key: model_params_md5, data: data)
    end

    private

    def optimize
      return if ENV["RIGHTS_API_DISABLE_OFFSET_OPTIMIZER"]
      return if offset.zero?

      cached = Services[:cache][model_params_md5]
      return if cached.nil?

      # Next page: cached value located cached limit or more items earlier than desired offset
      # We are counting across the cached page and starting after the last result.
      if cached[:offset] <= @offset - cached[:limit]
        @where = parser.model.optimizer_query(value: cached[:last])
        @offset -= cached[:limit] + cached[:offset]
        Services[:logger].info "\e[31mCACHE HIT: NEW OFFSET #{@offset}\e[0m"
      end
    end

    # Canonicalization ensures that reordering query params in the URL won't affect
    # the ability to get cache hits on subsequent queries.
    # We don't want to be sensitive to OFFSET or LIMIT because we keep those as part
    # of the cache value.
    def model_params_md5
      canonical = parser.params.clone
      canonical.delete "offset"
      canonical.delete "limit"
      Digest::MD5.hexdigest(parser.model.to_s + canonical.to_json_c14n)
    end
  end
end
