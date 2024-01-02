# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(QueryParser) do
    # @param params [Hash] CGI parameters of the form {"key" => ["value1", ...], ...}
    # @param schema_class [Class] Schema subclass for the table being queried
    # def initialize(params:, schema_class:)

    let(:query_parser) { described_class.new(params: {}, schema_class: RightsSchema) }
    # let(:id_query) { described_class.new(params: "id=some+id", table_name: "rights") }

    describe ".new" do
      it "creates a #{described_class}" do
        expect(query_parser).to be_an_instance_of(described_class)
      end

      it "parses a complex query" do
        params = {
          "attribute" => [">=3", "<=9"],
          "reason" => [">3", "<9", "!7"],
          "source" => ["[1,2]"],
          "order" => ["id desc"],
          "offset" => ["10"],
          "limit" => ["20"]
        }
        parser = described_class.new(params: params, schema_class: RightsSchema)
        expect(parser.where.count).to be > 0
        expect(parser.order.count).to be > 0
        expect(parser.offset).to eq 10
        expect(parser.limit).to eq 20
      end
    end
  end
end
