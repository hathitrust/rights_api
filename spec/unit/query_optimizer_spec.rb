# frozen_string_literal: true

module RightsAPI
  RSpec.describe(QueryOptimizer) do
    let(:query_parser) { QueryParser.new(model: RightsCurrent).parse }
    let(:query_optimizer) { described_class.new(parser: query_parser) }

    describe "#initialize" do
      it "creates RightsAPI::QueryOptimizer instance" do
        expect(query_optimizer).to be_a(RightsAPI::QueryOptimizer)
        expect(query_optimizer.parser).to be_a(RightsAPI::QueryParser)
        expect(query_optimizer.offset).to be_a(Integer)
        expect(query_optimizer.where).to be_an(Array)
      end
    end

    describe "#add_to_cache" do
      it "adds an entry to the cache" do
        query_optimizer.add_to_cache(dataset: RightsCurrent.base_dataset.all)
        expect(Services[:cache].count).to be > 0
      end
    end
  end
end
