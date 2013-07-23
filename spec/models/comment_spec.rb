require 'spec_helper'

describe Comment do
  let(:user) { User.make! }
  let(:photograph) { Photograph.make!(user: User.make!) }
  let(:comment_thread) { CommentThread.make!(user: user, threadable: photograph) }

  it { should belong_to(:user) }
  it { should belong_to(:comment_thread) }
  it { should have_many(:notifications) }
  it { should have_many(:reports) }

  [:user_id, :comment_thread_id, :body].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "scopes" do
    let(:published_comment) { 
      Comment.make!(published: true, comment_thread: comment_thread, user: user)
    }

    it "returns published comments" do
      Comment.published.should include(published_comment)
    end
  end

  describe "notifications" do
    let(:comment) { Comment.make(comment_thread: comment_thread) }
    let(:notification) { Notification.make(notifiable: comment) }
    let(:photo_user) { User.make(locale: "en") }
    let(:comment_user) { User.make(locale: "fr") }


    describe "#notify" do
      it "creates a notification" do
        comment.notifications.should_receive(:create)
        comment.notify
      end

      describe "locales" do
        let(:comment) { Comment.make(user: comment_user) }

        it "uses the target's locale" do
          I18n.should_receive(:with_locale).with(photo_user.locale)
          comment.notify
        end
      end
    end

    describe "#toggle_visibility" do
      before { comment.stub(:save) { true } }

      it "creates a notification" do
        comment.notifications.should_receive(:create)
        comment.toggle_visibility
      end

      describe "locales" do
        let(:comment) { Comment.make(user: comment_user) }

        it "uses the target's locale" do
          I18n.should_receive(:with_locale).with(comment_user.locale)
          comment.toggle_visibility
        end
      end
    end
  end
end
