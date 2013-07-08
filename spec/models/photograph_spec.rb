require 'spec_helper'

describe Photograph do
  let(:user) { User.make! }
  let(:photograph) { Photograph.make(user: user) }
  subject { photograph }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_one(:metadata) }
    it { should have_many(:collection_photographs) }
    it { should have_many(:collections).through(:collection_photographs) }
    it { should belong_to(:license) }
    it { should have_many(:recommendations) }
    it { should belong_to(:category) }
    it { should have_many(:favourites) }
    it { should have_many(:favourited_by_users).through(:favourites) }
    it { should have_many(:comment_threads) }
    it { should have_many(:comments).through(:comment_threads) }
  end

  describe "validations" do
    [:user_id, :image_uid].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end

  describe "delegations" do
    let(:metadata) { Metadata.make(photograph: photograph) }

    [:title, :description, :keywords, :format, :landscape?, :portrait?, :square?].each do |field|
      it { should respond_to(field) }
    end

    it "responds to URL helpers" do
      photograph.url_helpers.root_path.should eq(Rails.application.routes.url_helpers.root_path)
    end
  end

  describe "images" do
    describe "accessors" do
      [:image, :standard_image, :homepage_image, :large_image, :thumbnail_image].each do |image|
        it { should respond_to(image) }
      end
    end

    describe "processing" do
      describe "#processing?" do
        let(:metadata) { Metadata.make(photograph: photograph) }
        before(:each) { photograph.stub(:metadata) { metadata } }

        context "images processing" do
          before(:each) do
            metadata.stub(:processing) { false }
          end

          it "returns true when image sizes have yet to be generated" do
            photograph.stub(:processing) { true }
            photograph.processing?.should be_true
          end

          it "returns false when image sizes are generated" do
            photograph.stub(:processing) { false }
            photograph.processing?.should be_false
          end
        end

        context "metadata processing" do
          before(:each) do
            photograph.stub(:processing) { false }
          end

          it "returns true when metadata is marked as processing" do
            metadata.stub(:processing) { true }
            photograph.processing?.should be_true
          end

          it "returns true if metadata is missing for whatever reason" do
            photograph.stub(:metadata) { nil }
            photograph.processing?.should be_true
          end

          it "returns false if metadata is present and not processing" do
            metadata.stub(:processing) { false }
            photograph.processing?.should be_false
          end
        end
      end
    end
  end

  describe "atomic counters" do
    describe "#views" do
      before(:each) { photograph.stub(:id) { 1 } }

      it "is a redis counter" do
        photograph.views.class.should eq(Redis::Counter)
      end

      it "is incrementable" do
        photograph.views.increment.should be_true
      end
    end
  end
end
