# frozen_string_literal: true

require "canister"
require "logger"
require "lru_redux"

require_relative "database"

DEFAULT_CACHE_SIZE = 1000

module RightsAPI
  Services = Canister.new

  Services.register(:cache) do
    LruRedux::Cache.new(DEFAULT_CACHE_SIZE)
  end

  Services.register(:database) do
    Database.new
  end

  Services.register(:logger) do
    Logger.new($stdout, level: ENV.fetch("RIGHTS_API_LOGGER_LEVEL", Logger::WARN).to_i)
  end

  Services.register(:database_connection) do
    Services[:database].connect.tap do |connection|
      connection.logger = Services[:logger]
    end
  end
end
