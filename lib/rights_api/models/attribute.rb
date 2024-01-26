# frozen_string_literal: true

module RightsAPI
  class Attribute < Sequel::Model
    extend ModelExtensions

    def to_h
      {
        id: id,
        type: type,
        name: name,
        description: dscr
      }
    end
  end
end
