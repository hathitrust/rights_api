# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(Query) do
    let(:query) { described_class.new(model: Attribute) }
    let(:query_with_params) { described_class.new(model: Attribute, params: {id: [1]}) }
    let(:query_with_limit) { described_class.new(model: Attribute, params: {limit: [2]}) }

    describe ".new" do
      it "creates a Query" do
        expect(query).to be_a(described_class)
      end
    end

    describe "#run" do
      context "with an id" do
        it "returns a Result" do
          expect(query_with_params.run).to be_a_kind_of(Result)
        end
      end

      context "without an id" do
        it "returns a Result" do
          expect(query.run).to be_a_kind_of(Result)
        end
      end

      context "with a limit" do
        it "returns a Result with a Cursor" do
          expect(query_with_limit.run).to be_a_kind_of(Result)
          expect(query_with_limit.run.cursor).to be_a(String)
        end
      end
    end
  end
end
