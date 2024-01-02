# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(Query) do
    let(:query) { described_class.new(table_name: "rights") }
    let(:id_query) { described_class.new(params: "id=some+id", table_name: "rights") }

    describe ".new" do
      it "creates a Query" do
        expect(query).to be_an_instance_of(described_class)
      end
    end

    describe "#run" do
      context "with an id" do
        it "returns a Result" do
          expect(id_query.run).to be_a_kind_of(Result)
        end
      end

      context "without an id" do
        it "returns a Result" do
          expect(query.run).to be_a_kind_of(Result)
        end
      end
    end
  end
end
