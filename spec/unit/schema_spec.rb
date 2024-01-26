# frozen_string_literal: true

require "sequel"

module RightsAPI
  RSpec.describe(Schema) do
    describe ".names" do
      it "returns an Array of table names" do
        expect(described_class.names).to be_an_instance_of(Array)
        expect(described_class.names.count).to be > 0
        described_class.names.each do |name|
          expect(name).to be_an_instance_of(Symbol)
        end
      end
    end

    describe ".model_for" do
      it "returns a Class for each table name" do
        described_class.names.each do |name|
          expect(described_class.model_for(name: name)).to be_a_kind_of(Class)
        end
      end
    end
  end
end
