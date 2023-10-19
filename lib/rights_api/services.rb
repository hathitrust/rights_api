# frozen_string_literal: true

require "canister"
require "rights_database"

module RightsAPI
  Services = Canister.new
  Services.register(:rights_database) do
    RightsDatabase
  end
end
