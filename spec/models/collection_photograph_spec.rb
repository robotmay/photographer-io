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
    let(:now) { Time.now }
    let(:last_photo_added_at) { now - 15.minutes }
    let(:photograph) { Photograph.make }

    before { Timecop.freeze(now) }
    before { collection.stub(:last_photo_added_at) { last_photo_added_at } }
    before { collection.stub(:update_column) { double.as_null_object } }
    after { collection_photograph.run_callbacks(:create) }

    it "calls #set_last_photo_added_at" do
      collection_photograph.should_receive(:set_last_photo_added_at)
    end

    context "now is higher than previous" do
      let(:now) { Time.now }

      it "updates the last_photo_added_at field" do
        collection.should_receive(:update_column).with(:last_photo_added_at, now)
      end
    end

    context "photo created_at is lower than previous" do
      let(:last_photo_added_at) { now + 5.minutes }

      it "doesn't update the last_photo_added_at field" do
        collection.should_not_receive(:update_column)
      end
    end

    context "no previous time is set" do
      before { collection.stub(:last_photo_added_at) { nil } }

      it "updates the last_photo_added_at field" do
        collection.should_receive(:update_column).with(:last_photo_added_at, now)
      end
    end
  end
end
