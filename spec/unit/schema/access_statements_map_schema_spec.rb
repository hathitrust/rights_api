# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(AccessStatementsMapSchema) do
    let(:schema) { described_class.new(table: :access_statements_map) }
    let(:unexpanded_row) { {id: 1, a_attr: "a", a_access_profile: "ap"} }
    let(:expanded_row) { {id: 1, attribute: "a", access_profile: "ap"} }

    describe "#normalize_row" do
      it "expands abbreviations" do
        expect(schema.normalize_row(row: unexpanded_row)).to eq(expanded_row)
      end

      it "returns the same object" do
        expect(schema.normalize_row(row: unexpanded_row)).to be(unexpanded_row)
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
