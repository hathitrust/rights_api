# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(AccessStatementsSchema) do
    let(:row_data) {
      {
        stmt_key: "test_stmt_key",
        stmt_url: "test_stmt_url",
        stmt_head: "test_stmt_head",
        stmt_text: "test_stmt_text",
        stmt_url_aux: "test_stmt_url_aux",
        stmt_icon: "test_stmt_icon",
        stmt_icon_aux: "test_stmt_icon_aux"
      }
    }
    let(:hash_data) {
      {
        statement_key: "test_stmt_key",
        statement_url: "test_stmt_url",
        statement_head: "test_stmt_head",
        statement_text: "test_stmt_text",
        statement_url_aux: "test_stmt_url_aux",
        statement_icon: "test_stmt_icon",
        statement_icon_aux: "test_stmt_icon_aux"
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
          expect(described_class.query_for_key(key: :statement_icon_aux)).to be_a_kind_of(Sequel::SQL::Expression)
        end
      end

      context "with unknown key" do
        it "raises" do
          expect { described_class.query_for_key(key: :stmt_icon_aux) }.to raise_error(StandardError)
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
