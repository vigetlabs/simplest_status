require 'spec_helper'

RSpec.describe SimplestStatus::Status do
  subject { described_class.new [:such_status, 1337] }

  describe "#name" do
    it { expect(subject.name).to eq :such_status }
  end

  describe "#value" do
    it { expect(subject.value).to eq 1337 }
  end

  describe "#symbol" do
    it { expect(subject.symbol).to eq :such_status }
  end

  describe "#string" do
    it { expect(subject.string).to eq 'such_status' }
  end

  describe "#to_s" do
    it { expect(subject.to_s).to eq 'such_status' }
  end

  describe "#to_hash" do
    it { expect(subject.to_hash).to eq(:such_status => 1337) }
  end

  describe "#matches?" do
    it { expect(subject.matches?(:such_status)).to eq true }
    it { expect(subject.matches?('such_status')).to eq true }
    it { expect(subject.matches?(1337)).to eq true }
    it { expect(subject.matches?('1337')).to eq true }
    it { expect(subject.matches?(:boom)).to eq false }
  end

  describe "#constant_name" do
    it { expect(subject.constant_name).to eq 'SUCH_STATUS' }
  end

  describe "#label" do
    it { expect(subject.label).to eq 'Such Status' }
  end

  describe "#for_select" do
    it { expect(subject.for_select).to eq ['Such Status', 1337] }
  end

  describe "#==" do
    it { expect(subject).to eq described_class.new [:such_status, 1337] }
    it { expect(subject).to_not eq described_class.new [:very_status, 10] }
  end
end
