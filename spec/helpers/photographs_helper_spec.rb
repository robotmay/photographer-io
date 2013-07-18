require 'spec_helper'

describe PhotographsHelper do
  let(:photograph) { Photograph.make(metadata: metadata) }
  let(:metadata) { Metadata.make }

  describe "photo_tag" do
    context "photo is nil" do
      let(:photograph) { nil }

      it "returns nil" do
        helper.photo_tag(photograph).should be_nil 
      end
    end

    context "deprecated" do
      before { photograph.stub(:has_precalculated_sizes?) { false } }

      pending
    end

    context "processing" do
      before { photograph.stub(:processing?) { true } }

      it "returns a processing image" do
        helper.photo_tag(photograph).should match(/processing_(.*)\.jpg/i)
      end
    end
  end
end
