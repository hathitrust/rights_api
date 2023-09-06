require "spec_helper"
require "rack/test"
# require "nokogiri"
# require "set"

RSpec.describe "RightsAPI" do
  include Rack::Test::Methods

  let(:rights_api_endpoint) { "/" }

  def valid_json?(json)
    JSON.parse(json)
    true
  rescue JSON::ParserError, TypeError => _e
    false
  end

  shared_examples "valid Rights API response" do
    it "returns ok" do
      expect(last_response).to be_ok
    end

    it "returns JSON" do
      expect(last_response.content_type).to eq("application/json")
    end

    it "returns valid JSON" do
      expect(valid_json?(last_response.body)).to be true
    end
  end

  shared_examples "Rights API 400 response" do
    it "does not return ok" do
      expect(last_response).not_to be_ok
    end

    it "returns 400" do
      expect(last_response.status).to eq 400
    end
  end

  describe "/" do
    before(:each) { get rights_api_endpoint }
    it_behaves_like "valid Rights API response"

    it "has usage summary" do
      expect(JSON.parse(last_response.body)["usage"]).not_to be_nil
    end
  end

  describe "/attributes" do
    before(:each) { get(rights_api_endpoint + "attributes") }
    it_behaves_like "valid Rights API response"
  end

  describe "/access_profiles" do
    before(:each) { get(rights_api_endpoint + "access_profiles") }
    it_behaves_like "valid Rights API response"
  end

  describe "/reasons" do
    before(:each) { get(rights_api_endpoint + "reasons") }
    it_behaves_like "valid Rights API response"
  end

  describe "/rights" do
    context "with a valid HTID" do
      before(:each) { get(rights_api_endpoint + "rights", {htid: "test.pd_google"}) }
      it_behaves_like "valid Rights API response"
    end

    context "with no HTID" do
      before(:each) { get(rights_api_endpoint + "rights") }
      it_behaves_like "Rights API 400 response"
    end
  end

  describe "/sources" do
    before(:each) { get(rights_api_endpoint + "sources") }
    it_behaves_like "valid Rights API response"
  end
end
