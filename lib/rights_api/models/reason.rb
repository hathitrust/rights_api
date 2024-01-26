# frozen_string_literal: true

module RightsAPI
  class Reason < Sequel::Model
    extend ModelExtensions

    def to_h
      {
        id: id,
        name: name,
        description: dscr
      }
    end
  end
end
