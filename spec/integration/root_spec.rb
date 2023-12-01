# frozen_string_literal: true

require "spec_helper"
require "rack/test"

RSpec.describe "RightsAPI" do
  include Rack::Test::Methods

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
end
