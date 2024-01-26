# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(Attribute) do
    let(:hash_keys) { %i[id type name description].sort.freeze }

    describe "#base_dataset" do
      it "returns self" do
        expect(described_class.base_dataset).to eq(described_class)
      end
    end

    describe "#default_key" do
      it "returns a Symbol" do
        expect(described_class.default_key).to be_an_instance_of(Symbol)
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
