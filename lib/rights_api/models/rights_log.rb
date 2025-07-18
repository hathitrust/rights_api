# frozen_string_literal: true

module RightsAPI
  class RightsLog < Sequel::Model(:rights_log)
    extend ModelExtensions
    # The obnoxious *_obj naming convention arises from the fact that apparently
    # Sequel wants our foreign keys to be of the form attribute_id, reason_id, etc.
    # but of course they're not, so much silliness ensues.
    many_to_one :access_profile_obj, class: :"RightsAPI::AccessProfile", key: :access_profile
    many_to_one :attribute_obj, class: :"RightsAPI::Attribute", key: :attr
    many_to_one :reason_obj, class: :"RightsAPI::Reason", key: :reason
    many_to_one :source_obj, class: :"RightsAPI::Source", key: :source
    set_primary_key [:namespace, :id, :time]

    # Maybe TOO eager. This makes us partially responsible for the fact that rights_current.source
    # has an embedded access_profile.
    def self.base_dataset
      eager_graph(:attribute_obj, :reason_obj, :access_profile_obj, source_obj: :access_profile_obj)
    end

    def self.default_key
      :htid
    end

    # @param [String, Symbol] field
    # @return [Sequel::SQL::Expression]
    def self.query_for_field(field:)
      if field.to_sym == :htid
        return Sequel.join [qualify(field: :namespace), qualify(field: :id)], "."
      end
      super
    end

    # rights_current and rights_log should order by htid, timestamp
    # @return [Array<RightsAPI::Order>]
    def self.default_order
      [
        Order.new(column: :namespace),
        Order.new(column: :id),
        Order.new(column: :time)
      ]
    end

    def to_h
      {
        namespace: namespace,
        id: id,
        htid: namespace + "." + id,
        attribute: attribute_obj.to_h,
        reason: reason_obj.to_h,
        source: source_obj.to_h,
        access_profile: access_profile_obj.to_h,
        time: time
      }
    end
  end
end
