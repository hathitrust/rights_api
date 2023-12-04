require "spec_helper"
require "rack/test"

STANDARD_TABLES = %w[attributes access_profiles access_statements access_statements_map reasons sources]

def valid_identifier_for_table(name)
  return "pd" if name == "access_statements"
  return "pd.google" if name == "access_statements_map"
  "1"
end

RSpec.describe "RightsAPI" do
  include Rack::Test::Methods

  let(:rights_api_endpoint) { "/v1/" }

  def valid_json?(json)
    JSON.parse(json)
    true
  rescue JSON::ParserError, TypeError => _e
    false
  end

  shared_examples "valid response" do
    it "returns valid JSON with no error" do
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq("application/json")
      expect(valid_json?(last_response.body)).to be true
    end
  end

  shared_examples "empty response" do
    it "returns empty JSON with no error" do
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq("application/json")
      expect(valid_json?(last_response.body)).to be true
      expect(JSON.parse(last_response.body)["data"].count).to eq(0)
    end
  end

  shared_examples "nonempty response" do
    it "returns empty JSON with no error" do
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq("application/json")
      expect(valid_json?(last_response.body)).to be true
      expect(JSON.parse(last_response.body)["data"].count).to be > 0
    end
  end

  shared_examples "404 response" do
    it "returns an HTTP 404 response" do
      expect(last_response).not_to be_ok
      expect(last_response.status).to eq 404
    end
  end

  describe "/" do
    before(:each) { get rights_api_endpoint }
    it_behaves_like "valid response"
    it_behaves_like "empty response"
  end

  describe "/ redirect" do
    before(:each) { get "/" }

    it "redirects to current version" do
      expect(last_response.status).to eq 302
      expect(last_response.location).to match(/v1/)
    end
  end

  STANDARD_TABLES.each do |table|
    describe "/#{table}" do
      before(:each) { get(rights_api_endpoint + table) }
      it_behaves_like "valid response"
    end
  end

  STANDARD_TABLES.each do |table|
    describe "/#{table}/:id" do
      context "with a valid identifier" do
        identifier = valid_identifier_for_table(table)
        before(:each) { get(rights_api_endpoint + table + "/#{identifier}") }
        it_behaves_like "valid response"
      end

      context "with an invalid identifier" do
        before(:each) { get(rights_api_endpoint + table + "/no_such_id") }
        it_behaves_like "empty response"
      end
    end
  end

  describe "/rights" do
    context "with a valid HTID" do
      before(:each) { get(rights_api_endpoint + "rights/test.pd_google") }
      it_behaves_like "valid response"
      it_behaves_like "nonempty response"
    end

    context "with an invalid HTID" do
      before(:each) { get(rights_api_endpoint + "rights/bogus.no_such_id") }
      it_behaves_like "valid response"
      it_behaves_like "empty response"
    end

    context "with no HTID" do
      before(:each) { get(rights_api_endpoint + "rights") }
      it_behaves_like "valid response"
      it_behaves_like "nonempty response"
    end
  end

  describe "/rights_log" do
    context "with a valid HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log/test.pd_google") }
      it_behaves_like "valid response"
      it_behaves_like "nonempty response"
    end

    context "with an invalid HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log/bogus.no_such_id") }
      it_behaves_like "valid response"
      it_behaves_like "empty response"
    end

    context "with no HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log") }
      it_behaves_like "valid response"
      it_behaves_like "nonempty response"
    end
  end
end
