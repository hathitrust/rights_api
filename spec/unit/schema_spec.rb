# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(Schema) do
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

    describe ".class_for" do
      it "returns a Class for each table name" do
        described_class.names.each do |name|
          expect(described_class.class_for(name: name)).to be_a_kind_of(Class)
        end
      end
    end

    describe "#primary_key" do
      it "returns a Symbol" do
        expect(described_class.primary_key).to be_an_instance_of(Symbol)
      end
    end

    describe "#query_for_key" do
      it "returns a Sequel expression" do
        expect(described_class.query_for_key(key: :some_key)).to be_a_kind_of(Sequel::SQL::Expression)
      end
    end

    describe "#default_order" do
      it "returns a Sequel expression" do
        expect(described_class.default_order).to be_a_kind_of(Sequel::SQL::Expression)
      end
    end
  end
end
