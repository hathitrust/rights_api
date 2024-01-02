# frozen_string_literal: true

require "canister"
require_relative "database"

module RightsAPI
  Services = Canister.new

  Services.register(:rights_database) do
    Database.new
  end

  Services.register(:logger) do
    Logger.new($stdout, level: ENV.fetch("RIGHTS_API_LOGGER_LEVEL", Logger::WARN).to_i)
  end

  Services.register(:db_connection) do
    Services[:rights_database].connect.tap do |connection|
      connection.logger = Services[:logger]
    end
  end
end
