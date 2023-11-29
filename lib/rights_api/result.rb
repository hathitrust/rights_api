# frozen_string_literal: true

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

    # Override this to add any custom fields to the default ones.
    def finalize(hash)
      hash
    end
  end

  class ErrorResult < Result
    def initialize(exception:)
      super()
      @exception = exception
    end

    def finalize(hash)
      hash[:error] = @exception.to_s
      hash
    end
  end

  class UsageResult < Result
    USAGE = <<~END_USAGE
      API_URL => this usage summary
      API_URL/access_profiles => contents of the access_profiles table
      API_URL/access_profiles/1 => access_profile entry with id=1
      API_URL/access_statements => contents of the access_stmts table
      API_URL/access_statements/pd => access_stmts entry with stmt_key=pd
      API_URL/attributes => contents of the attributes table
      API_URL/attributes/1 => attributes entry with id=1
      API_URL/reasons => contents of the reasons table
      API_URL/reasons/1 => reasons entry with id=1
      API_URL/rights/HTID => query rights_current for current rights on HTID
      API_URL/rights_log/HTID => query rights_current for rights history on HTID
    END_USAGE

    def finalize(hash)
      hash[:usage] = USAGE
      hash
    end
  end
end
