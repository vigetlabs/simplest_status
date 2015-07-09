require 'spec_helper'

RSpec.describe SimplestStatus do
  it "has a version number" do
    expect(SimplestStatus::VERSION).not_to be nil
  end

  context "when extended by a model" do
    class EmptyModel
      extend SimplestStatus

      def self.validates(*args)
        #no op
      end

      statuses :boom, :shaka, :laka

      simple_status :jam_level, %i(heating_up on_fire)
    end

    describe ".statuses" do
      it { expect(EmptyModel.statuses).to eq(:boom => 0, :shaka => 1, :laka => 2) }
    end

    describe ".simple_status" do
      it { expect(EmptyModel.jam_levels).to eq(:heating_up => 0, :on_fire => 1) }
    end
  end
end
