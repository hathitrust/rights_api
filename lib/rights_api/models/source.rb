# frozen_string_literal: true

module RightsAPI
  class Source < Sequel::Model
    extend ModelExtensions
    # one_to_many :rights_current, model: "RightsAPI::RightsCurrent".to_sym, key: :source
    # one_to_many :rights_log, model: "RightsAPI::RightsCurrent".to_sym, key: :source
    many_to_one :access_profile_obj, class: :"RightsAPI::AccessProfile", key: :access_profile
    set_primary_key :id

    def self.base_dataset
      eager_graph(:access_profile_obj)
    end

    def to_h
      {
        id: id,
        name: name,
        description: dscr,
        access_profile: access_profile_obj.to_h,
        digitization_source: digitization_source
      }
    end
  end
end
