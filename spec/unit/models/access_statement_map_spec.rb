# frozen_string_literal: true

require "sequel/sql"

module RightsAPI
  RSpec.describe(AccessStatementMap) do
    let(:hash_keys) { %i[attribute access_profile statement_key].sort.freeze }

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
        expect(described_class.default_order).to be_a(Sequel::SQL::Expression)
      end
    end

    describe "#query_for_field" do
      context "with default key" do
        it "returns a Sequel string expression" do
          expect(described_class.query_for_field(field: described_class.default_key)).to be_a(Sequel::SQL::StringExpression)
        end
      end

      context "with non-default key" do
        it "returns a Sequel expression" do
          expect(described_class.query_for_field(field: :some_field)).to be_a_kind_of(Sequel::SQL::QualifiedIdentifier)
        end
      end
    end

    describe "#to_h" do
      it "returns expected structure" do
        expect(described_class.first.to_h.keys.sort).to eq(hash_keys)
      end
    end
  end
end
