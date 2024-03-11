# frozen_string_literal: true

module RightsAPI
  class Attribute < Sequel::Model
    extend ModelExtensions
    set_primary_key :id

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
