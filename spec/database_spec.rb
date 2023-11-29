# frozen_string_literal: true

require "spec_helper"

RSpec.describe RightsAPI::Database do
  describe "#initialize" do
    it "creates RightsAPI::Database instance" do
      expect(described_class.new).to be_an_instance_of(RightsAPI::Database)
    end
  end

  describe "#connect" do
    it "connects with built-in connection string" do
      expect(described_class.new).not_to be nil
    end

    it "connects with explicit connection string" do
      expect(described_class.new.connect(ENV["RIGHTS_DATABASE_CONNECTION_STRING"])).not_to be nil
    end

    it "connects with connection arguments" do
      ENV.with(RIGHTS_DATABASE_CONNECTION_STRING: nil) do
        args = {user: "ht_rights", password: "ht_rights", host: "mariadb",
                database: "ht", adapter: "mysql2"}
        expect(described_class.new.connect(**args)).not_to be nil
      end
    end

    it "connects with ENV variables" do
      env = {RIGHTS_DATABASE_CONNECTION_STRING: nil,
             RIGHTS_DATABASE_USER: "ht_rights",
             RIGHTS_DATABASE_PASSWORD: "ht_rights",
             RIGHTS_DATABASE_HOST: "mariadb",
             RIGHTS_DATABASE_DATABASE: "ht",
             RIGHTS_DATABASE_ADAPTER: "mysql2"}
      ENV.with(**env) do
        expect(described_class.new.connect).not_to be nil
      end
    end
  end
end
