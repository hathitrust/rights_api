# frozen_string_literal: true

module RightsAPI
  RSpec.describe(ErrorResult) do
    let(:result) { described_class.new(exception: StandardError.new) }
    let(:test_row) { {key1: "value1", key2: "value2"} }

    describe ".new" do
      it "creates ErrorResult instance" do
        expect(result).to be_a(RightsAPI::ErrorResult)
      end
    end

    describe "#to_h" do
      it "returns a Hash with an error key" do
        expect(result.to_h).to be_a(Hash)
        expect(result.to_h.key?(:error)).to eq(true)
      end
    end
  end
end
