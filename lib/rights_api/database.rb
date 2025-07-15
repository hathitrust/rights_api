# frozen_string_literal: true

require "sequel"

module RightsAPI
  class Database
    attr_reader :connection

    def initialize
      @connection = Sequel.connect(
        adapter: :mysql2,
        user: ENV["MARIADB_HT_RO_USERNAME"],
        password: ENV["MARIADB_HT_RO_PASSWORD"],
        host: ENV["MARIADB_HT_RO_HOST"],
        database: ENV["MARIADB_HT_RO_DATABASE"],
        encoding: "utf8mb4"
      )
      @connection.extension(:connection_validator)
      @connection.pool.connection_validation_timeout = 5
    end
  end
end
