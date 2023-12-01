# frozen_string_literal: true

require "rack/test"

require "spec_helper"
require "shared_examples"

RSpec.describe "/rights_log" do
  include Rack::Test::Methods

  describe "/rights_log/HTID" do
    context "with a valid HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log/test.pd_google") }
      it_behaves_like "nonempty response"
    end

    context "with an invalid HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log/bogus.no_such_id") }
      it_behaves_like "empty response"
    end

    context "with no HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log") }
      it_behaves_like "nonempty response"
    end
  end
end
