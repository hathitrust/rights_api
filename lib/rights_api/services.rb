# frozen_string_literal: true

require "canister"
require "logger"
require "rights_database"

module RightsAPI
  Services = Canister.new
  Services.register(:rights_database) do
    RightsDatabase
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
