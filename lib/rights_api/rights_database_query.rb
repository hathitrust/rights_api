# frozen_string_literal: true

require "rights_database"
require_relative "services"

module RightsAPI
  def access_profiles
    @attributes ||= db_connection[:access_profiles].to_hash(:id)
  end

  def attributes
    @attributes ||= db_connection[:attributes].to_hash(:id)
  end

  def reasons
    @reasons ||= db_connection[:reasons].to_hash(:id)
  end

  # FIXME: rights_database needs a to_h for Rights objects
  # FIXME: db-image could use seeds for rights_log maybe based on rights_current
  # but with an initial ic/bib entry.
  def rights(htid)
    entry = RightsAPI::Services[:rights_database]::Rights.new(item_id: htid)
    {item_id: entry.item_id,
     htid: entry.item_id,
     namespace: entry.namespace,
     id: entry.id,
     attribute_id: entry.attribute.id,
     attribute_name: entry.attribute.name,
     reason_id: entry.reason.id,
     reason_name: entry.reason.name,
     source_id: entry.source.id,
     source_name: entry.source.name,
     access_profile_id: entry.access_profile.id,
     access_profile_name: entry.access_profile.name,
     time: entry.time,
     note: entry.note,
     user: entry.user}
  end

  def sources
    @sources ||= db_connection[:sources].to_hash(:id)
  end

  module_function :access_profiles, :attributes, :reasons, :rights, :sources

  private

  def db_connection
    Services[:rights_database]::DB.connection
  end

  module_function :db_connection
end
