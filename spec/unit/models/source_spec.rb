# frozen_string_literal: true

require "sequel/sql"

module RightsAPI
  RSpec.describe(Source) do
    let(:hash_keys) { %i[id name description access_profile digitization_source].sort.freeze }

    describe "#base_dataset" do
      it "returns self" do
        expect(described_class.base_dataset).to be_a(Sequel::Mysql2::Dataset)
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
      it "returns expected keys" do
        expect(described_class.first.to_h.keys.sort).to eq(hash_keys)
      end
    end
  end
end
