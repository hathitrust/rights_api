require "spec_helper"
require "rack/test"

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
      expect(JSON.parse(last_response.body).count).to eq(0)
    end
  end

  shared_examples "404 response" do
    it "returns an HTTP 404 response" do
      expect(last_response).not_to be_ok
      expect(last_response.status).to eq 404
    end
  end

  # rights and rights_log responses are arrays rather than hashes
  shared_examples "rights response" do
    it "returns an array" do
      expect(JSON.parse(last_response.body)).to be_an_instance_of(Array)
    end
  end

  describe "/" do
    before(:each) { get rights_api_endpoint }
    it_behaves_like "valid response"

    it "has usage summary" do
      expect(JSON.parse(last_response.body)["usage"]).not_to be_nil
    end
  end

  describe "/ redirect" do
    before(:each) { get "/" }

    it "redirects to current version" do
      expect(last_response.status).to eq 302
      expect(last_response.location).to match(/v1/)
    end
  end

  RightsAPI::App::STANDARD_TABLES.each do |table|
    describe "/#{table}" do
      before(:each) { get(rights_api_endpoint + table) }
      it_behaves_like "valid response"
    end
  end

  RightsAPI::App::STANDARD_TABLES.each do |table|
    describe "/#{table}/:id" do
      context "with a valid identifier" do
        identifier = (table == "access_statements") ? "pd" : "1"
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
      it_behaves_like "rights response"
      it_behaves_like "valid response"
    end

    context "with an invalid HTID" do
      before(:each) { get(rights_api_endpoint + "rights/bogus.no_such_id") }
      it_behaves_like "rights response"
      it_behaves_like "empty response"
    end

    context "with no HTID" do
      before(:each) { get(rights_api_endpoint + "rights") }
      it_behaves_like "404 response"
    end
  end

  describe "/rights_log" do
    context "with a valid HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log/test.pd_google") }
      it_behaves_like "rights response"
      it_behaves_like "valid response"
    end

    context "with an invalid HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log/bogus.no_such_id") }
      it_behaves_like "rights response"
      it_behaves_like "empty response"
    end

    context "with no HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log") }
      it_behaves_like "404 response"
    end
  end
end
