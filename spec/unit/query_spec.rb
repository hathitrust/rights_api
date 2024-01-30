# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(Query) do
    let(:query) { described_class.new(table_name: "rights") }

    describe ".new" do
      it "creates a Query" do
        expect(query).to be_a(described_class)
      end
    end

    describe "#run" do
      context "with an id" do
        it "returns a Result" do
          expect(query.run(id: "some id")).to be_a_kind_of(Result)
        end
      end

      context "without an id" do
        it "returns a Result" do
          expect(query.run(id: nil)).to be_a_kind_of(Result)
        end
      end
    end
  end
end
