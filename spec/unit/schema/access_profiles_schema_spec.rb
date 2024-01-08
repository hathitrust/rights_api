# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(AccessProfilesSchema) do
    let(:row_data) {
      {
        id: 1,
        name: "test_name",
        dscr: "test_dscr"
      }
    }
    let(:hash_data) {
      {
        id: 1,
        name: "test_name",
        description: "test_dscr"
      }
    }

    describe "#to_h" do
      it "returns expected structure" do
        expect(described_class.new(row: row_data).to_h).to eq(hash_data)
      end
    end
  end
end
