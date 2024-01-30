# frozen_string_literal: true

require "sequel/sql"

module RightsAPI
  RSpec.describe(Reason) do
    let(:hash_keys) { %i[id name description].sort.freeze }

    describe "#base_dataset" do
      it "returns self" do
        expect(described_class.base_dataset).to eq(described_class)
      end
    end

    describe "#default_key" do
      it "returns a Symbol" do
        expect(described_class.default_key).to be_a(Symbol)
      end
    end

    describe "#default_order" do
      it "returns SQL expression" do
        expect(described_class.default_order).to be_a(Sequel::SQL::QualifiedIdentifier)
      end
    end

    describe "#to_h" do
      it "returns expected structure" do
        expect(described_class.first.to_h.keys.sort).to eq(hash_keys)
      end
    end
  end
end
