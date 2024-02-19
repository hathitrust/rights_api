# frozen_string_literal: true

module RightsAPI
  class QueryParserError < StandardError
    # This is raised whenever the query parser determines the query is ill-formed.
    # Should result in a 400 Bad Request response
  end
end
