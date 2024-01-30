# frozen_string_literal: true

module RightsAPI
  class AccessProfile < Sequel::Model
    extend ModelExtensions
    one_to_many :source, model: :"RightsAPI::Source", key: :access_profile

    def to_h
      {
        id: id,
        name: name,
        description: dscr
      }
    end
  end
end
