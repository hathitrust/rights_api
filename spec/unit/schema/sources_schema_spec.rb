# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(SourcesSchema) do
    let(:row_data) {
      {
        id: 1,
        name: "test_name",
        dscr: "test_dscr",
        access_profile: 1,
        digitization_source: "test_digitization_source"
      }
    }
    let(:hash_data) {
      {
        id: 1,
        name: "test_name",
        description: "test_dscr",
        access_profile: 1,
        digitization_source: "test_digitization_source"
      }
    }

    describe "#primary_key" do
      it "returns a Symbol" do
        expect(described_class.primary_key).to be_an_instance_of(Symbol)
      end
    end

    describe "#query_for_key" do
      context "with primary key" do
        it "returns a Sequel identifier" do
          expect(described_class.query_for_key(key: described_class.primary_key)).to be_an_instance_of(Sequel::SQL::Identifier)
        end
      end

      context "with non-primary key" do
        it "returns a Sequel expression" do
          expect(described_class.query_for_key(key: :description)).to be_a_kind_of(Sequel::SQL::Expression)
        end
      end

      context "with unknown key" do
        it "raises" do
          expect { described_class.query_for_key(key: :dscr) }.to raise_error(StandardError)
        end
      end
    end

    describe "#to_h" do
      it "returns expected structure" do
        expect(described_class.new(row: row_data).to_h).to eq(hash_data)
      end
    end
  end
end
