# frozen_string_literal: true

require_relative "services"

module RightsAPI
  def access_statements
    @access_statements ||= db_connection[:access_stmts].to_hash(:stmt_key)
  end

  def access_profiles
    @access_profiles ||= db_connection[:access_profiles].to_hash(:id)
  end

  def attributes
    @attributes ||= db_connection[:attributes].to_hash(:id)
  end

  def reasons
    @reasons ||= db_connection[:reasons].to_hash(:id)
  end

  def rights(htid)
    rights_query(htid: htid, table: :rights_current)
  end

  def rights_log(htid)
    rights_query(htid: htid, table: :rights_log)
  end

  def sources
    @sources ||= db_connection[:sources].to_hash(:id)
  end

  module_function :access_profiles, :access_statements, :attributes, :reasons,
    :rights, :rights_log, :sources

  private

  def db_connection
    Services[:rights_database].db
  end
  
  # Common code for querying rights or rights_log and returning results
  def rights_query(htid:, table:)
    namespace, id = htid.split(".", 2)
    result = []
    db_connection[table]
      .where(:namespace => namespace, Sequel.qualify(table, :id) => id)
      .order(:time)
      .each do |entry|
      result <<
        {
          htid: entry[:namespace] + "." + entry[:id],
          namespace: entry[:namespace],
          id: entry[:id],
          attribute: entry[:attr],
          reason: entry[:reason],
          source: entry[:source],
          access_profile: entry[:access_profile],
          time: entry[:time]
        }
      # Keep note and user out of structure for public API
    end
    result
  end

  module_function :db_connection, :rights_query
end
