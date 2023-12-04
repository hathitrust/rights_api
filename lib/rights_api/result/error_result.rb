# frozen_string_literal: true

module RightsAPI
  class ErrorResult < Result
    def initialize(exception:)
      super()
      @exception = exception
    end

    private

    def finalize(hash)
      hash[:error] = @exception.to_s
      hash
    end
  end
end
