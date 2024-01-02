# frozen_string_literal: true

require "spec_helper"
require "rack/test"

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
  end

  context "with offset parameter" do
    context "with integer offset" do
      before(:each) { get(rights_api_endpoint + "rights?offset=10") }
      it_behaves_like "nonempty rights response"
      it "starts at 11" do
        start = parse_json(last_response.body)[:start]
        expect(start).to eq 11
      end
    end

    context "with bogus offset" do
      before(:each) { get(rights_api_endpoint + "rights?offset=shwoozle") }
      it_behaves_like "400 response"
    end
  end

  context "with limit parameter" do
    context "with integer limit" do
      before(:each) { get(rights_api_endpoint + "rights?limit=2") }
      it_behaves_like "nonempty rights response"
      it "returns 2 rows" do
        count = parse_json(last_response.body)[:data].count
        expect(count).to eq 2
      end
    end

    context "with bogus limit" do
      before(:each) { get(rights_api_endpoint + "rights?limit=shwoozle") }
      it_behaves_like "400 response"
    end
  end

  context "with order parameter" do
    context "time asc" do
      before(:each) { get(rights_api_endpoint + "rights?order=time+asc") }
      it_behaves_like "nonempty rights response"
      it "sorts by time in ascending order" do
        times = parse_json(last_response.body)[:data].map { |entry| entry[:time] }
        expect(times.sort).to eq times
      end
    end

    context "time desc" do
      before(:each) { get(rights_api_endpoint + "rights?order=time+desc") }
      it_behaves_like "nonempty rights response"
      it "sorts by time in descending order" do
        times = parse_json(last_response.body)[:data].map { |entry| entry[:time] }
        expect(times.sort.reverse).to eq times
      end
    end
  end
end
