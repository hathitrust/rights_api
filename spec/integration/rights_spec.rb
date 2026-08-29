# frozen_string_literal: true

require "rack/test"
require "shared_examples"

RSpec.describe "/rights" do
  include Rack::Test::Methods

  describe "/rights_log/HTID" do
    context "with a valid HTID" do
      before(:each) { get(rights_api_endpoint + "rights/test.pd_google") }
      it_behaves_like "nonempty rights response"
    end

    context "with an invalid HTID" do
      before(:each) { get(rights_api_endpoint + "rights/bogus.no_such_id") }
      it_behaves_like "empty response"
    end
  end

  context "with no HTID" do
    before(:each) { get(rights_api_endpoint + "rights") }
    it_behaves_like "nonempty rights response"

    it "obeys default sort order `namespace, id, time`" do
      response = parse_json(last_response.body)
      sorted = response[:data].sort do |a, b|
        a[:namespace] <=> b[:namespace] ||
          collator.compare(a[:id], b[:id]) ||
          a[:time] <=> b[:time]
      end
      expect(response[:data]).to eq(sorted)
    end
  end

  context "with a cursor" do
    before(:each) { get(rights_api_endpoint + "rights?limit=2") }
    it_behaves_like "nonempty rights response"

    it "returns a cursor" do
      response = parse_json(last_response.body)
      expect(response[:cursor]).to be_a(String)
    end

    it "produces next page of results when cursor is used" do
      response_1 = parse_json(last_response.body)
      cursor = response_1[:cursor]
      get(rights_api_endpoint + "rights?limit=2&cursor=#{cursor}")
      response_2 = parse_json(last_response.body)
      expect(response_2[:total]).to eq(response_1[:total])
      expect(response_2[:start]).to eq(3)
    end
  end
end
