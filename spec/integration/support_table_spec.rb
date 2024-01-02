# frozen_string_literal: true

require "rack/test"
require "shared_examples"

SUPPORT_TABLES = %w[
  access_profiles
  access_statements
  access_statements_map
  attributes
  reasons
  sources
]

SUPPORT_TABLES.each do |table|
  RSpec.shared_examples "nonempty #{table} response" do
    it_behaves_like "nonempty response"
    it "has valid #{table} data" do
      response = parse_json(last_response.body)
      response[:data].each do |row|
        validator = "validate_#{table}_row".to_sym
        send validator, row
      end
    end
  end
end

valid_identifier_for_table = {
  "access_statements" => "pd",
  "access_statements_map" => "pd.google"
}.tap { |h| h.default = 1 }

RSpec.describe "RightsAPI Support Tables" do
  include Rack::Test::Methods

  SUPPORT_TABLES.each do |table|
    describe "/#{table}" do
      before(:each) { get(rights_api_endpoint + table) }
      it_behaves_like "nonempty #{table} response"
    end
  end

  SUPPORT_TABLES.each do |table|
    describe "/#{table}/:id" do
      context "with a valid identifier" do
        identifier = valid_identifier_for_table[table]
        before(:each) { get(rights_api_endpoint + table + "/#{identifier}") }
        it_behaves_like "nonempty #{table} response"
      end

      context "with an invalid identifier" do
        before(:each) { get(rights_api_endpoint + table + "/no_such_id") }
        it_behaves_like "empty response"
      end
    end
  end
end
