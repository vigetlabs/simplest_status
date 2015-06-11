require 'spec_helper'

RSpec.describe SimplestStatus do
  it "has a version number" do
    expect(SimplestStatus::VERSION).not_to be nil
  end

  context "when extended by a model" do
    class EmptyModel
      extend SimplestStatus
    end

    before do
      allow(EmptyModel).to receive(:include).with(SimplestStatus::ModelMethods)
    end

    it "adds the .statuses method" do
      expect(EmptyModel.statuses(:boom, :shaka, :laka)).to eq(:boom => 0, :shaka => 1, :laka => 2)
    end
  end
end
