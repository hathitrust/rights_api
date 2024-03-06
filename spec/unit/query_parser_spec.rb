# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(QueryParser) do
    let(:query_parser) { described_class.new(model: Attribute) }
    # let(:id_query) { described_class.new(params: "id=some+id", table_name: "rights") }

    describe ".new" do
      it "creates a #{described_class}" do
        expect(query_parser).to be_a(described_class)
      end

      it "has the expected attribute readers" do
        %i[model where order offset limit].each do |reader|
          expect(query_parser.send(reader)).not_to be_nil
        end
      end
    end

    describe "#parse" do
      it "parses empty query into zero WHERE clauses" do
        expect(query_parser.parse.where.count).to eq(0)
      end

      it "parses id query into one WHERE clause" do
        expect(query_parser.parse(params: {id: ["1"]}).where.count).to eq(1)
      end

      it "parses OFFSET query" do
        expect(query_parser.parse(params: {offset: ["1"]}).offset).to eq(1)
      end

      it "parses LIMIT query" do
        expect(query_parser.parse(params: {limit: ["5"]}).limit).to eq(5)
      end

      it "raises on bogus LIMIT queries" do
        expect { query_parser.parse(params: {limit: ["a"]}) }.to raise_error(QueryParserError)
      end

      it "raises on bogus OFFSET queries" do
        expect { query_parser.parse(params: {offset: ["a"]}) }.to raise_error(QueryParserError)
      end
    end
  end
end
