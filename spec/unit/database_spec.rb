# frozen_string_literal: true

require "climate_control"

module RightsAPI
  RSpec.describe Database do
    describe "#initialize" do
      it "creates RightsAPI::Database instance" do
        expect(described_class.new).to be_a(RightsAPI::Database)
      end
    end

    describe "#connect" do
      it "connects with built-in connection string" do
        expect(described_class.new).not_to be nil
      end

      it "connects with explicit connection string" do
        expect(described_class.new.connect(ENV["RIGHTS_API_DATABASE_CONNECTION_STRING"])).not_to be nil
      end

      it "connects with connection arguments" do
        ClimateControl.modify(RIGHTS_API_DATABASE_CONNECTION_STRING: nil) do
          args = {
            user: "ht_rights",
            password: "ht_rights",
            host: "mariadb",
            database: "ht",
            adapter: "mysql2"
          }
          expect(described_class.new.connect(**args)).not_to be nil
        end
      end

      it "connects with ENV variables" do
        env = {
          RIGHTS_API_DATABASE_CONNECTION_STRING: nil,
          RIGHTS_API_DATABASE_USER: "ht_rights",
          RIGHTS_API_DATABASE_PASSWORD: "ht_rights",
          RIGHTS_API_DATABASE_HOST: "mariadb",
          RIGHTS_API_DATABASE_DATABASE: "ht",
          RIGHTS_API_DATABASE_ADAPTER: "mysql2"
        }
        ClimateControl.modify(**env) do
          expect(described_class.new.connect).not_to be nil
        end
      end
    end
  end
end
