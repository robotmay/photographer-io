require 'spec_helper'

describe Collection do
  let(:collection) { Collection.make }

  it { should belong_to(:user) }
  it { should have_many(:collection_photographs) }
  it { should have_many(:photographs).through(:collection_photographs) }
  it { should have_many(:reports) }
  
  [:user_id, :name].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "#cover_photo" do
    context "empty" do
      before { collection.photographs.each(&:destroy) }

      it "returns nil" do
        collection.cover_photo.should be_nil
      end
    end

    context "processing" do
      let(:processing_photograph) { collection.photographs.make(processing: true) }

      it "does not use processing photographs" do
        collection.cover_photo.should_not eq(processing_photograph)
      end
    end
  end
end
