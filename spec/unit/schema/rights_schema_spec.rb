# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(RightsSchema) do
    let(:schema) { described_class.new(table: :access_statements_map) }
    let(:unnormalized_row) { {namespace: "test", id: "001", attr: 1, user: "someone", note: "a note"} }
    let(:normalized_row) { {namespace: "test", id: "001", attribute: 1, htid: "test.001"} }

    describe "#normalize_row" do
      it "adds htid and removes user, note" do
        expect(schema.normalize_row(row: unnormalized_row)).to eq(normalized_row)
      end

      it "returns the same object" do
        expect(schema.normalize_row(row: unnormalized_row)).to be(unnormalized_row)
      end
    end

    describe "#primary_key" do
      it "returns a Symbol" do
        expect(schema.primary_key).to be_an_instance_of(Symbol)
      end
    end

    describe "#query_for_field" do
      context "with primary key" do
        it "returns a Sequel string expression" do
          expect(schema.query_for_field(field: schema.primary_key)).to be_an_instance_of(Sequel::SQL::StringExpression)
        end
      end

      context "with non-primary key" do
        it "returns a Sequel expression" do
          expect(schema.query_for_field(field: :some_field)).to be_a_kind_of(Sequel::SQL::Expression)
        end
      end
    end
  end
end
