require 'spec_helper'

describe Photograph do
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
    let(:user) { User.make! }
    let(:photograph) { Photograph.make(user: user) }

    subject { photograph }

    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:image_uid) }
  end
end
