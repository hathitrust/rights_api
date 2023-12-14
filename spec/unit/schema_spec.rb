# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(Schema) do
    let(:schema) { described_class.new(table: :attributes) }
    let(:unexpanded_row) { {id: 1, attr_name: "n", dscr: "d", some_stmt: "s"} }
    let(:expanded_row) { {id: 1, attribute_name: "n", description: "d", some_statement: "s"} }

    describe ".names" do
      it "returns an Array of table names" do
        expect(described_class.names).to be_an_instance_of(Array)
        expect(described_class.names.count).to be > 0
        described_class.names.each do |name|
          expect(name).to be_an_instance_of(Symbol)
        end
      end
    end

    describe ".named" do
      it "returns a Schema for each table name" do
        described_class.names.each do |name|
          expect(described_class.named(name: name)).to be_a_kind_of(described_class)
        end
      end
    end

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
      it "returns a Sequel expression" do
        expect(schema.query_for_field(field: :some_field)).to be_a_kind_of(Sequel::SQL::Expression)
      end
    end

    describe "#default_order" do
      it "returns a Sequel expression" do
        expect(schema.default_order).to be_a_kind_of(Sequel::SQL::Expression)
      end
    end
  end
end
