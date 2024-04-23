# frozen_string_literal: true

module RightsAPI
  RSpec.describe Cursor do
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
          expect(described_class.new).to be_a(RightsAPI::Cursor)
        end
      end

      context "with a bogus cursor string" do
        it "raises ArgumentError" do
          expect { described_class.new(INVALID_CURSOR) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
