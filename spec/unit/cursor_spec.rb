# frozen_string_literal: true

module RightsAPI
  RSpec.describe Cursor do
    let(:empty_cursor) { described_class.new }

    describe ".encode" do
      context "with an object" do
        it "returns a string" do
          expect(described_class.encode({})).to be_a(String)
        end
      end

      context "with nil" do
        it "returns a string" do
          expect(described_class.encode(nil)).to be_a(String)
        end
      end
    end

    describe ".decode" do
      context "with a valid cursor string" do
        it "returns an object" do
          expect(described_class.decode(VALID_CURSOR)).to be_a(Array)
        end
      end

      context "with a bogus cursor string" do
        it "raises ArgumentError" do
          expect { described_class.decode(INVALID_CURSOR) }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#initialize" do
      context "with a valid cursor string" do
        it "creates RightsAPI::Cursor instance" do
          expect(described_class.new(cursor_string: VALID_CURSOR)).to be_a(RightsAPI::Cursor)
        end
      end

      context "with an empty cursor string" do
        it "creates RightsAPI::Cursor instance" do
          expect(empty_cursor).to be_a(RightsAPI::Cursor)
        end
      end

      context "with a bogus cursor string" do
        it "raises ArgumentError" do
          expect { described_class.new(INVALID_CURSOR) }.to raise_error(ArgumentError)
        end
      end
    end

    describe "#encode" do
      it "returns the expected cursor string" do
        expected = described_class.encode([1, "test", "cc-by-3.0_google", "2009-01-01 05:00:00 +0000"])
        row = {namespace: "test", id: "cc-by-3.0_google", time: "2009-01-01 05:00:00 +0000"}
        expect(empty_cursor.encode(order: RightsCurrent.default_order, rows: [row])).to eq(expected)
      end
    end

    describe "#where" do
      context "with no results" do
        it "returns an empty Array" do
          expect(empty_cursor.where(model: RightsCurrent, order: [])).to match_array([])
        end
      end

      it "produces a one-element Array with a Sequel literal" do
        cursor_string = described_class.encode([0, "test", "cc-by-3.0_google", "2009-01-01 05:00:00 +0000"])
        cursor = described_class.new(cursor_string: cursor_string)
        expected = <<~END.delete("\n")
          (rights_current.namespace>'test') OR
           (rights_current.namespace='test' AND rights_current.id>'cc-by-3.0_google') OR
           (rights_current.namespace='test' AND rights_current.id='cc-by-3.0_google' AND rights_current.time>'2009-01-01 05:00:00 +0000')
        END
        expect(cursor.where(model: RightsCurrent, order: RightsCurrent.default_order).first.to_s).to eq(expected)
      end
    end
  end
end
