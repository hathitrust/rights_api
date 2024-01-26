# frozen_string_literal: true

require "sequel"

require_relative "model_extensions"
require_relative "models/access_profile"
require_relative "models/access_statement_map"
require_relative "models/access_statement"
require_relative "models/attribute"
require_relative "models/reason"
require_relative "models/rights_current"
require_relative "models/rights_log"
require_relative "models/source"

# Information on the various tables and their contents.
# Used mainly to translate between the more human-readable API keys
# and their corresponding abbreviated or SQLized counterparts.
# This data might migrate into app.rb.
module RightsAPI
  class Schema
    TABLE_NAME_TO_MODEL = {
      access_profiles: AccessProfile,
      access_statements: AccessStatement,
      access_statements_map: AccessStatementMap,
      attributes: Attribute,
      reasons: Reason,
      rights: RightsCurrent,
      rights_log: RightsLog,
      sources: Source
    }.freeze
    private_constant :TABLE_NAME_TO_MODEL

    def self.names
      TABLE_NAME_TO_MODEL.keys.sort
    end

    # Return model class corresponding to a table name.
    # @param name [String, Symbol] A table name
    # @return [Class]
    def self.model_for(name:)
      TABLE_NAME_TO_MODEL[name.to_sym]
    end
  end
end
