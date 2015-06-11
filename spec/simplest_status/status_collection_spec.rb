require 'spec_helper'

RSpec.describe SimplestStatus::StatusCollection do
  let(:boom)  { SimplestStatus::Status.new([:boom, 0]) }
  let(:shaka) { SimplestStatus::Status.new([:shaka, 1]) }
  let(:laka)  { SimplestStatus::Status.new([:laka, 2]) }

  subject { described_class.new }

  describe "#each" do
    subject { described_class.new.merge!(:boom => 0, :shaka => 1, :laka => 2) }

    it "yields each key/value as a Simplest::Status object" do
      expect { |block| subject.each(&block) }.to yield_successive_args(boom, shaka, laka)
    end
  end

  describe "#add" do
    it "returns the collection with the added record" do
      expect(subject.add(:testing)).to eq(:testing => 0)
    end

    context "when given an explicit value" do
      it { expect(subject.add(:testing, 5)).to eq(:testing => 5) }
    end
  end

  describe "#status_for" do
    subject { described_class[:testing, 5] }

    context "given input that matches a status's name" do
      it "returns a SimplestStatus::Status with the matching name" do
        expect(subject.status_for(:testing)).to eq SimplestStatus::Status.new([:testing, 5])
      end
    end

    context "given input that matches a status's value" do
      it "returns a SimplestStatus::Status with the matching value" do
        expect(subject.status_for(5)).to eq SimplestStatus::Status.new([:testing, 5])
      end
    end

    context "given input that does not match a status's name or value" do
      it "returns nil" do
        expect(subject.status_for('boom')).to eq nil
      end
    end
  end

  describe "#[] and #value_for" do
    context "given a value that matches an existing key" do
      subject { described_class[:testing, 0] }

      it { expect(subject[:testing]).to eq 0 }
      it { expect(subject.value_for(:testing)).to eq 0 }
    end

    context "given a value that matches an existing key once converted" do
      let(:symbol) { described_class[:testing, 0] }
      let(:string) { described_class['testing', 0] }

      it { expect(symbol['testing']).to eq 0 }
      it { expect(string[:testing]).to eq 0 }

      it { expect(symbol.value_for('testing')).to eq 0 }
      it { expect(string.value_for(:testing)).to eq 0 }
    end
  end

  describe "#label_for" do
    subject { described_class[:such_label, 1337] }

    it { expect(subject.label_for('such_label')).to eq 'Such Label' }
    it { expect(subject.label_for(1337)).to eq 'Such Label' }
  end

  describe "#for_select" do
    subject { described_class.new.merge!(:boom => 0, :shaka => 1, :laka => 2) }

    it { expect(subject.for_select).to eq [['Boom', 0], ['Shaka', 1], ['Laka', 2]] }
  end
end
