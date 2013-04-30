require 'spec_helper'

describe Metadata do
  it { should belong_to(:photograph) }

  [:photograph_id].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "methods" do
    let(:metadata) { Metadata.new }

    describe "#keywords" do
      it "is an array" do
        metadata.keywords = ['nature', 'squirrel']
        metadata.keywords.should be_a(Array)
      end
    end
  end
end
