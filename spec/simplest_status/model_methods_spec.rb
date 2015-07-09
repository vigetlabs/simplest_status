require 'spec_helper'

RSpec.describe SimplestStatus::ModelMethods do
  class MockModel < Struct.new(:hype_level)
    class << self
      attr_accessor :validation_input

      def validates(field, options)
        self.validation_input = options.merge(:field => field)
      end
    end

    def hype_level
      self.class.hype_levels[super]
    end
  end

  let!(:statuses) { SimplestStatus::StatusCollection.new(:hype_level).merge!(:boom => 0, :shaka => 1, :laka => 2) }

  subject { described_class.new(MockModel, statuses) }

  describe "#add" do
    before { subject.add }

    it "defines and populates the model-level accessor" do
      expect(MockModel.hype_levels).to eq(:boom => 0, :shaka => 1, :laka => 2)
    end

    it "sets a constant for each status" do
      expect(MockModel::BOOM).to eq 0
      expect(MockModel::SHAKA).to eq 1
      expect(MockModel::LAKA).to eq 2
    end

    it "defines a class-level scopes" do
      expect(MockModel).to receive(:where).with(:hype_level => 1)

      MockModel.shaka
    end

    it "defines instance-level predicate methods" do
      expect(MockModel.new(:boom).boom?).to eq true
      expect(MockModel.new(:shaka).boom?).to eq false
      expect(MockModel.new(:laka).boom?).to eq false
    end

    it "defines instance-level status mutation methods" do
      MockModel.new(:boom).tap do |subject|
        expect(subject).to receive(:update_attributes).with(:hype_level => 2)

        subject.laka
      end
    end

    it "defines an instance-level label method for each status" do
      expect(MockModel.new(:boom).hype_level_label).to eq 'Boom'
      expect(MockModel.new(:shaka).hype_level_label).to eq 'Shaka'
      expect(MockModel.new(:laka).hype_level_label).to eq 'Laka'
    end
    
    it "sets up the correct model validations" do
      MockModel.validation_input.tap do |validation|
        expect(validation[:field]).to eq :hype_level
        expect(validation[:presence]).to eq true
        expect(validation[:inclusion][:in]).to eq [0, 1, 2]
      end
    end
  end
end
