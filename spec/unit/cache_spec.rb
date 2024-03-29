# frozen_string_literal: true

module RightsAPI
  RSpec.describe(Cache) do
    let(:cache) { described_class.new(size: 2) }

    describe "#add" do
      it "adds data" do
        cache.add(key: "key", data: "data")
        expect(cache["key"]).to eq "data"
      end

      it "replaces existing data" do
        cache.add(key: "key", data: "data")
        cache.add(key: "key", data: "different data")
        expect(cache["key"]).to eq "different data"
      end

      it "replaces oldest data" do
        cache.add(key: "key1", data: "data1")
        cache.add(key: "key2", data: "data2")
        cache.add(key: "key3", data: "data3")
        expect(cache["key1"]).to be_nil
      end
    end
  end
end
