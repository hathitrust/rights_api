# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(AccessStatementsSchema) do
    let(:schema) { described_class.new(table: :access_statements) }

    describe "#primary_key" do
      it "returns a Symbol" do
        expect(schema.primary_key).to be_an_instance_of(Symbol)
      end
    end
  end
end
