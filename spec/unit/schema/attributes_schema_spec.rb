# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(AttributesSchema) do
    let(:row_data) {
      {
        id: 1,
        type: "test_type",
        name: "test_name",
        dscr: "test_dscr"
      }
    }
    let(:hash_data) {
      {
        id: 1,
        type: "test_type",
        name: "test_name",
        description: "test_dscr"
      }
    }

    describe "#primary_key" do
      it "returns a Symbol" do
        expect(described_class.primary_key).to be_an_instance_of(Symbol)
      end
    end

    describe "#to_h" do
      it "returns expected structure" do
        expect(described_class.new(row: row_data).to_h).to eq(hash_data)
      end
    end
  end
end
