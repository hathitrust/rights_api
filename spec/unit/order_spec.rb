# frozen_string_literal: true

module RightsAPI
  RSpec.describe Order do
    let(:order) { described_class.new(column: :id) }
    let(:order_desc) { described_class.new(column: :id, asc: false) }

    describe ".new" do
      it "creates a #{described_class}" do
        expect(order).to be_a(described_class)
      end

      it "has the expected attribute reader" do
        %i[column].each do |reader|
          expect(order.send(reader)).not_to be_nil
        end
      end
    end

    describe "#asc?" do
      context "with default direction" do
        it "returns true" do
          expect(order.asc?).to eq true
        end
      end

      context "with asc false" do
        it "returns false" do
          expect(order_desc.asc?).to eq false
        end
      end
    end

    describe "#to_sequel" do
      context "with default direction" do
        it "returns Sequel::SQL::OrderedExpression with #descending == false" do
          expect(order.to_sequel(model: RightsCurrent)).to be_a(Sequel::SQL::OrderedExpression)
          expect(order.to_sequel(model: RightsCurrent).descending).to eq(false)
        end
      end

      context "with asc false" do
        it "returns Sequel::SQL::OrderedExpression with #descending == true" do
          expect(order_desc.to_sequel(model: RightsCurrent)).to be_a(Sequel::SQL::OrderedExpression)
          expect(order_desc.to_sequel(model: RightsCurrent).descending).to eq(true)
        end
      end
    end
  end
end
