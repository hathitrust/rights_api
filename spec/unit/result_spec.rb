# frozen_string_literal: true

module RightsAPI
  REQUIRED_HASH_KEYS = %w[total start end milliseconds data]
  RSpec.describe(Result) do
    let(:result) { described_class.new }
    let(:test_row) { {key1: "value1", key2: "value2"} }

    describe ".new" do
      context "with no parameters" do
        it "uses defaults for offset and total" do
          expect(result.offset).to eq(0)
          expect(result.total).to eq(0)
        end

        it "sets start, and, and data to initial values" do
          expect(result.start).to eq(0)
          expect(result.end).to eq(0)
          expect(result.data).to eq([])
          expect(result.milliseconds).to eq(0.0)
        end
      end

      context "with parameters" do
        it "uses provided offset and total" do
          res = described_class.new(offset: 10, total: 100, milliseconds: 100.0)
          expect(res.offset).to eq(10)
          expect(res.total).to eq(100)
          expect(res.total).to eq(100.0)
        end
      end
    end

    describe "#add!" do
      it "returns self" do
        res = result
        expect(res.add!(row: {})).to equal(res)
      end

      it "adds the data to the end of the data array" do
        expect(result.add!(row: test_row).data.last).to eq(test_row)
      end

      it "updates start and end" do
        expect(result.add!(row: test_row).start).to eq(1)
        expect(result.add!(row: test_row).end).to eq(2)
      end
    end

    describe "#more?" do
      context "with a total greater than rows added" do
        it "returns true" do
          res = described_class.new(total: 4)
          2.times { |i| res.add! row: {} }
          expect(res.more?).to be true
        end
      end

      context "with a total equal to rows added" do
        it "returns false" do
          res = described_class.new(total: 4)
          4.times { |i| res.add! row: {} }
          expect(res.more?).to be false
        end
      end
    end

    describe "#cursor=" do
      it "sets the cursor" do
        res = described_class.new(total: 1)
        res.cursor = "cursor"
        expect(res.cursor).to eq "cursor"
      end
    end

    describe "#to_h" do
      it "returns a hash" do
        expect(result.to_h).to be_a(Hash)
      end

      it "returns a hash with the expected keys" do
        REQUIRED_HASH_KEYS.each do |key|
          expect(result.to_h.key?(key)).to eq(true)
        end
      end
    end
  end
end
