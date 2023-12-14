# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(Query) do
    let(:schema) { Schema.named(name: :rights) }
    let(:query) { described_class.new(schema: schema) }

    describe ".new" do
      it "creates a Query" do
        expect(query).to be_an_instance_of(described_class)
      end

      it "exposes its schema" do
        expect(query.schema).to eq(schema)
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
