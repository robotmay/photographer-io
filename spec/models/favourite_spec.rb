require 'spec_helper'

describe Favourite do
  let(:favourite) { Favourite.make(photograph: photograph) }
  let(:photograph) { Photograph.make(metadata: Metadata.make) }
  let(:photo_user) { photograph.user }
  let(:user) { favourite.user }
  let(:counter) { double("counter", increment: true, decrement: true) }

  it { should belong_to(:user) }
  it { should belong_to(:photograph) }
  it { should have_many(:notifications) }

  [:user_id, :photograph_id].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "#adjust_photograph_score" do
    let!(:score) { favourite.photograph.score }

    it "increments the score by 1" do
      favourite.adjust_photograph_score
      favourite.photograph.score.should eq(score + 1)
    end
  end

  describe "#notify" do
    let(:notification) { Notification.make(notifiable: favourite) }

    context "notify_favourites is true" do
      before(:each) do
        user.stub(:notify_favourites) { true }
      end

      it "creates a notification" do
        favourite.notifications.should_receive(:create)
        favourite.notify
      end

      describe "locales" do
        let(:photo_user) { User.make(locale: "en") }
        let(:favourite_user) { User.make(locale: "fr") }
        let(:favourite) { Favourite.make(user: favourite_user) }

        it "uses the target's locale" do
          I18n.should_receive(:with_locale).with(photo_user.locale)
          favourite.notify
        end
      end
    end

    context "notify_favourites is false" do
      before(:each) { user.stub(:notify_favourites) { false } }

      it "doesn't create a notification" do
        favourite.notify
        favourite.notifications.should be_empty
      end
    end
  end

  describe "callbacks" do
    before do
      favourite.stub(:persisted?) { true }
      favourite.stub(:notify) { true }
      photo_user.stub(:received_favourites_count) { counter }
      photo_user.stub(:push_stats) { true }
    end

    context "create" do
      it "increments user stats" do
        photo_user.received_favourites_count.should_receive(:increment)  
        favourite.run_callbacks(:create)
      end

      it "notifies the photo owner" do
        favourite.should_receive(:notify)
        favourite.run_callbacks(:create) 
      end

      it "pushes the new stats" do
        photo_user.should_receive(:push_stats)
        favourite.run_callbacks(:create)
      end
    end

    context "destroy" do
      it "decrements user stats" do
        photo_user.received_favourites_count.should_receive(:decrement)  
        favourite.run_callbacks(:destroy)
      end

      it "pushes the new stats" do
        photo_user.should_receive(:push_stats)
        favourite.run_callbacks(:destroy)
      end
    end
  end
end
