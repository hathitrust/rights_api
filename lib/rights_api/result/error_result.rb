# frozen_string_literal: true

module RightsAPI
  class ErrorResult < Result
    def initialize(exception:)
      super(offset: 0, total: 0)
      @exception = exception
    end

    private

    def finalize(hash)
      # FIXME: should we include the backtrace or just the message?
      hash[:error] = @exception.to_s + " #{@exception.backtrace}"
      hash
    end
  end
end
