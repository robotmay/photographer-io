require 'spec_helper'

describe PhotoExpansionWorker do
  subject { PhotoExpansionWorker.new }
  let(:photograph) { Photograph.make(metadata: metadata) }
  let(:metadata) { Metadata.make }

  before { Photograph.stub(:find) { photograph } }
  before { Metadata.stub(:find) { metadata } }
  before { photograph.stub(:save!) { true } }

  describe "metadata" do
    before { metadata.stub(:extract_from_photograph) { true } }
    before { metadata.stub(:save!) { true } }
    after { subject.perform(1) }

    it "calls extract_metadata" do
      subject.should_receive(:extract_metadata)
    end

    it "calls extract_from_photograph on the metadata" do
      metadata.should_receive(:extract_from_photograph)
    end

    it "saves the metadata" do
      metadata.should_receive(:save!)
    end
  end

  describe "image generation" do
    before { subject.instance_variable_set('@photo', photograph) }

    describe "#generate_standard_image" do
      let(:image) { double('image').as_null_object }
      before { photograph.stub_chain(:image, :thumb) { image } }
      after { subject.send(:generate_standard_image) }

      context "metadata.rotate? is true" do
        before { metadata.stub(:rotate?) { true } }
        before { metadata.stub(:rotate_by) { 90 } }

        it "rotates the image" do
          image.should_receive(:process).with(:rotate, 90)
        end
      end

      context "metadata.rotate? is false" do
        before { metadata.stub(:rotate?) { false } }

        it "doesn't rotate the image" do
          image.should_not_receive(:process)
        end
      end

      it "sets the standard image" do
        photograph.should_receive(:standard_image=)
      end
    end

    describe "#generate_images" do
      before { subject.stub(:generate_image) { true } }
      after { subject.send(:generate_images) }

      it "generates the standard image" do
        subject.should_receive(:generate_standard_image)
      end

      it "generates 3 smaller images" do
        
      end
    end
  end
end
