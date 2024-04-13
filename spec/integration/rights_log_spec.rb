# frozen_string_literal: true

require "climate_control"
require "ffi-icu"
require "rack/test"
require "shared_examples"

RSpec.describe "/rights_log" do
  include Rack::Test::Methods
  # Use ICU collator to try to approximate Sequel's collation of underscore vs Ruby's
  let(:collator) { ICU::Collation::Collator.new("en") }

  describe "/rights_log/HTID" do
    context "with a valid HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log/test.pd_google") }
      it_behaves_like "nonempty rights response"
    end

    context "with an invalid HTID" do
      before(:each) { get(rights_api_endpoint + "rights_log/bogus.no_such_id") }
      it_behaves_like "empty response"
    end
  end

  context "with no HTID" do
    before(:each) { get(rights_api_endpoint + "rights_log") }
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

  context "with an OFFSET" do
    before(:each) { get(rights_api_endpoint + "rights_log?limit=2") }

    it "produces the same results with or without optimizer" do
      optimized = parse_json get(rights_api_endpoint + "rights_log?limit=2&offset=2").body
      unoptimized = nil
      ClimateControl.modify(RIGHTS_API_DISABLE_OFFSET_OPTIMIZER: "1") do
        unoptimized = parse_json get(rights_api_endpoint + "rights_log?limit=2&offset=2").body
      end
      expect(optimized[:data]).to eq(unoptimized[:data])
    end
  end
end
