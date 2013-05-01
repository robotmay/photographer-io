require 'spec_helper'

describe Metadata do
  it { should belong_to(:photograph) }
  it { should have_one(:user).through(:photograph) }

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

    describe "#fetch_from_exif" do
      let(:exif) { {"WibblePT" => 100, "Wobbledave" => "Yes"} }

      it "returns an underscore-keyed array of matching keys" do
        hash = metadata.send(:fetch_from_exif, exif, [:wibble_pt])
        hash.should eq({
          wibble_pt: 100
        })
      end
    end
  end
end
