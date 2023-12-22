# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(RightsLogSchema) do
    let(:row_data) {
      {
        namespace: "test",
        id: "001",
        attr: 1,
        reason: 1,
        source: 1,
        access_profile: 1,
        user: "someone",
        note: "a note",
        time: "2018-01-01 12:00:00"
      }
    }
    let(:hash_data) {
      {
        namespace: "test",
        id: "001",
        htid: "test.001",
        attribute: 1,
        reason: 1,
        source: 1,
        access_profile: 1,
        time: "2018-01-01 12:00:00"
      }
    }

    describe "#primary_key" do
      it "returns a Symbol" do
        expect(described_class.primary_key).to be_an_instance_of(Symbol)
      end
    end

    describe "#default_order" do
      it "returns timestamp" do
        expect(described_class.default_order).to be(:time)
      end
    end

    describe "#query_for_field" do
      context "with primary key" do
        it "returns a Sequel string expression" do
          expect(described_class.query_for_field(field: described_class.primary_key)).to be_an_instance_of(Sequel::SQL::StringExpression)
        end
      end

      context "with non-primary key" do
        it "returns a Sequel expression" do
          expect(described_class.query_for_field(field: :some_field)).to be_a_kind_of(Sequel::SQL::Expression)
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
