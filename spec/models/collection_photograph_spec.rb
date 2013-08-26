require 'spec_helper'

describe CollectionPhotograph do
  let(:collection_photograph) { CollectionPhotograph.make }
  let(:collection) { Collection.make }
  let(:photograph) { Photograph.make }

  before { collection_photograph.stub(:collection) { collection } }
  before { collection_photograph.stub(:photograph) { photograph } }

  it { should belong_to(:collection) }
  it { should belong_to(:photograph) }

  describe "after_create" do
    let(:time) { Time.now }
    let(:photograph) { Photograph.make(created_at: time) }

    before { collection.stub(:last_photo_created_at) { Time.now } }
    before { collection.stub(:update_column) { double.as_null_object } }
    after { collection_photograph.run_callbacks(:create) }

    it "calls #set_last_photo_created_at" do
      collection_photograph.should_receive(:set_last_photo_created_at)
    end

    context "photo created_at is higher than previous" do
      let(:time) { 5.minutes.from_now }

      it "updates the last_photo_created_at field" do
        collection.should_receive(:update_column).with(:last_photo_created_at, time)
      end
    end

    context "photo created_at is lower than previous" do
      let(:time) { 5.minutes.ago }

      it "doesn't update the last_photo_created_at field" do
        collection.should_not_receive(:update_column)
      end
    end

    context "no previous time is set" do
      before { collection.stub(:last_photo_created_at) { nil } }

      it "updates the last_photo_created_at field" do
        collection.should_receive(:update_column).with(:last_photo_created_at, time)
      end
    end
  end
end
