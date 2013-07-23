require 'spec_helper'

describe Metadata do
  it { should belong_to(:photograph) }
  it { should have_one(:user).through(:photograph) }

  [:photograph_id].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "methods" do
    let(:metadata) { Metadata.new }

    describe "#title" do
      context "not blank" do
        before { metadata.stub(:read_attribute) { "Wibble" } }

        it "returns the title" do
          metadata.title.should eq("Wibble")
        end
      end

      context "blank" do
        before { I18n.stub(:t) { "Untitled" } }
        before { metadata.stub(:read_attribute) { "" } }

        it "returns untitled if blank" do
          metadata.title.should eq("Untitled")
        end
      end
    end

    describe "#keywords" do
      it "is an array" do
        metadata.keywords = ['nature', 'squirrel']
        metadata.keywords.should be_a(Array)
      end

      it "takes a string as input" do
        metadata.keywords = "nature, wibble"
        metadata.keywords.should eq(['nature', 'wibble'])
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
