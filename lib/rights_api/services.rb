# frozen_string_literal: true

require "canister"
require "rights_database"

module RightsAPI
  Services = Canister.new
  Services.register(:rights_database) do
    RightsDatabase
  end

  Services.register(:db_connection) do
    connection = Services[:rights_database].connect
    unless ENV["RIGHTS_API_NO_LOG"]
      connection.logger = Logger.new($stdout)
    end
    connection
  end
end
