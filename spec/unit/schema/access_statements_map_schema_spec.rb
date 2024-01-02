# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(AccessStatementsMapSchema) do
    let(:row_data) {
      {
        a_attr: "test_a_attr",
        a_access_profile: "test_a_access_profile",
        stmt_key: "test_stmt_key"
      }
    }
    let(:hash_data) {
      {
        attribute: "test_a_attr",
        access_profile: "test_a_access_profile",
        statement_key: "test_stmt_key"
      }
    }

    describe "#primary_key" do
      it "returns a Symbol" do
        expect(described_class.primary_key).to be_an_instance_of(Symbol)
      end
    end

    describe "#query_for_key" do
      context "with primary key" do
        it "returns a Sequel string expression" do
          expect(described_class.query_for_key(key: described_class.primary_key)).to be_an_instance_of(Sequel::SQL::StringExpression)
        end
      end

      context "with non-primary key" do
        it "returns a Sequel expression" do
          expect(described_class.query_for_key(key: :attribute)).to be_a_kind_of(Sequel::SQL::Expression)
        end
      end

      context "with unknown key" do
        it "raises" do
          expect { described_class.query_for_key(key: :a_attr) }.to raise_error(StandardError)
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
