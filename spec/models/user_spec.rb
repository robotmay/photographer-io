require 'spec_helper'

describe User do
  it { should have_many(:photographs) }
  it { should have_many(:collections) }
  it { should have_many(:recommendations) }
  it { should have_many(:favourites) }
  it { should have_many(:favourite_photographs).through(:favourites) }
  it { should have_many(:received_favourites).through(:photographs) }
  it { should have_many(:followee_followings) }
  it { should have_many(:followers).through(:followee_followings) }
  it { should have_many(:follower_followings) }
  it { should have_many(:followees).through(:follower_followings) }
  it { should have_many(:followee_photographs).through(:followees) }
  it { should have_many(:invitations) }
  it { should have_many(:comment_threads) }
  it { should have_many(:comments) }
  it { should have_many(:notifications) }
  it { should have_many(:authorisations) }
  it { should have_many(:old_usernames) }
  it { should have_many(:default_comment_threads) }
  it { should have_many(:reports) }

  it { should accept_nested_attributes_for(:default_comment_threads) }

  describe "default_comment_threads" do
    let(:user) { User.make }

    it "builds 3 blank threads" do
      user.build_default_comment_threads  
      user.default_comment_threads.size.should eq(3)
    end
  end

  describe "destroy" do
    let(:mock_args) do
      { :[]= => true, :save => true, :destroyed_by_association= => true }
    end

    let(:user) { User.make! }
    let(:photograph) { mock_model(Photograph, mock_args) }
    let(:collection) { mock_model(Collection, mock_args) }
    let(:recommendation) { mock_model(Recommendation, mock_args) }
    let(:favourite) { mock_model(Favourite, mock_args) }
    let(:following) { mock_model(Following, mock_args) }
    let(:comment_thread) { mock_model(CommentThread, mock_args) }
    let(:comment) { mock_model(Comment, mock_args) }
    let(:notification) { mock_model(Notification, mock_args) }
    let(:authorisation) { mock_model(Authorisation, mock_args) }
    let(:old_username) { mock_model(OldUsername, mock_args) }
    let(:default_comment_thread) { mock_model(CommentThread, mock_args) }

    after(:each) do
      user.destroy
    end

    it "destroys itself" do
      user.should_receive(:destroy)
    end

    it "destroys photographs" do
      user.photographs << photograph
      photograph.should_receive(:destroy)
    end

    it "destroys collections" do
      user.collections << collection
      collection.should_receive(:destroy)
    end

    it "destroys recommendations" do
      user.recommendations << recommendation
      recommendation.should_receive(:destroy)
    end

    it "destroys favourites" do
      user.favourites << favourite
      favourite.should_receive(:destroy)
    end

    it "destroys followings" do
      user.follower_followings << following
      following.should_receive(:destroy)
    end

    it "destroys comment threads" do
      user.comment_threads << comment_thread
      comment_thread.should_receive(:destroy)
    end

    it "destroys comments" do
      user.comments << comment
      comment.should_receive(:destroy)
    end
    
    it "destroys notifications" do
      user.notifications << notification
      notification.should_receive(:destroy)
    end

    it "destroys authorisations" do
      user.authorisations << authorisation
      authorisation.should_receive(:destroy)
    end

    it "destroys old usernames" do
      user.old_usernames << old_username
      old_username.should_receive(:destroy)
    end

    it "destroys default comment threads" do
      user.default_comment_threads << default_comment_thread
      default_comment_thread.should_receive(:destroy)
    end
  end

  describe "moderators" do
    context "is a moderator" do
      let(:user) { User.make(moderator: true) }

      it "is a moderator" do
        user.moderator?.should be_true
      end
    end

    context "is not a moderator" do
      let(:user) { User.make }

      it "is not a moderator" do
        user.moderator?.should be_false
      end
    end
  end
end
