require 'spec_helper'

describe DeviseExtensions::RegistrationsController do
  let(:user) { User.make! }

  before { sign_in user }
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  it "has a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "PUT update" do
    let(:thread) { CommentThread.make }

    it "saves default comment threads" do
      put :update, {
        user: {
          default_comment_threads_attributes: [{
            subject: thread.subject
          }]
        }
      }

      user.comment_threads.first.subject.should eq(thread.subject)
    end

    context "existing threads" do
      let!(:thread) { CommentThread.make!(threadable: user) }
      let!(:not_our_thread) { CommentThread.make!(threadable: User.make!) }

      it "deletes default comment threads" do
        put :update, {
          user: {
            default_comment_threads_attributes: [{
              id: thread.id,
              subject: thread.subject,
              _destroy: "1"
            }]
          }
        }

        user.comment_threads.size.should eq(0)
      end

      it "doesn't delete other people's threads" do
        expect {
          put :update, {
            user: {
              default_comment_threads_attributes: [{
                id: not_our_thread.id,
                subject: thread.subject,
                _destroy: "1"
              }]
            }
          }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
