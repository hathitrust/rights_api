# frozen_string_literal: true

module RightsAPI
  RSpec.describe(QueryParser) do
    let(:query_parser) { described_class.new(model: Attribute) }

    describe ".new" do
      it "creates a #{described_class}" do
        expect(query_parser).to be_a(described_class)
      end

      it "has the expected attribute readers" do
        %i[model where order limit cursor].each do |reader|
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

      it "parses cursor" do
        expect(query_parser.parse(params: {cursor: [VALID_CURSOR]}).cursor).to be_a(RightsAPI::Cursor)
      end

      it "raises on bogus cursor" do
        expect { query_parser.parse(params: {cursor: [INVALID_CURSOR]}) }.to raise_error(QueryParserError)
      end

      it "raises on multiple cursors" do
        expect { query_parser.parse(params: {cursor: [VALID_CURSOR, ANOTHER_VALID_CURSOR]}) }.to raise_error(QueryParserError)
      end

      it "parses LIMIT query" do
        expect(query_parser.parse(params: {limit: ["5"]}).limit).to eq(5)
      end

      it "raises on bogus LIMIT queries" do
        expect { query_parser.parse(params: {limit: ["a"]}) }.to raise_error(QueryParserError)
      end
    end
  end
end
