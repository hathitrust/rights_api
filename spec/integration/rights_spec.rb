# frozen_string_literal: true

require "rack/test"
require "shared_examples"

RSpec.describe "/rights" do
  include Rack::Test::Methods

  context "with a valid HTID" do
    before(:each) { get(rights_api_endpoint + "rights/test.pd_google") }
    it_behaves_like "nonempty rights response"
  end

  context "with an invalid HTID" do
    before(:each) { get(rights_api_endpoint + "rights/bogus.no_such_id") }
    it_behaves_like "empty response"
  end

  context "with no HTID" do
    before(:each) { get(rights_api_endpoint + "rights") }
    it_behaves_like "nonempty rights response"

    it "obeys default sort order `time ASC`" do
      response = parse_json(last_response.body)
      sorted = response[:data].sort_by { |a| a[:time] }
      expect(response[:data]).to eq(sorted)
    end
  end
end
