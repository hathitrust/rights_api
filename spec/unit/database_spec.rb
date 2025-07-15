# frozen_string_literal: true

require "climate_control"

RSpec.describe RightsAPI::Database do
  describe "#initialize" do
    it "creates RightsAPI::Database instance" do
      expect(described_class.new).to be_a(RightsAPI::Database)
    end
  end

  describe "#connect" do
    it "connects with ENV variables" do
      env = {
        MARIADB_HT_RO_USERNAME: "mdp-admin",
        MARIADB_HT_RO_PASSWORD: "mdp-admin",
        MARIADB_HT_RO_HOST: "mariadb",
        MARIADB_HT_RO_DATABASE: "ht"
      }
      ClimateControl.modify(**env) do
        expect(described_class.new.connection).not_to be nil
      end
    end
  end
end
