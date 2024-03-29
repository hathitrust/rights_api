# frozen_string_literal: true

module RightsAPI
  RSpec.describe(QueryOptimizer) do
    let(:query_parser) { QueryParser.new(model: RightsCurrent) }
    let(:query_optimizer) { described_class.new(parser: query_parser) }

    describe "#initialize" do
      it "creates RightsAPI::QueryOptimizer instance" do
        expect(query_optimizer).to be_a(RightsAPI::QueryOptimizer)
      end
    end
  end
end
