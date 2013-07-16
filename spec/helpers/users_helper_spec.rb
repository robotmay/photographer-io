require 'spec_helper'

describe UsersHelper do
  describe "follow_user_button" do
    let(:us) { User.make }
    let(:them) { User.make }

    context "signed in" do
      before do
        helper.stub(:user_signed_in?) { true }
        helper.stub(:current_user) { us }
      end
      
      it "shows the button" do
        helper.follow_user_button(them).should_not be_blank
      end

      context "they are us" do
        let(:them) { us }

        it "doesn't show the button" do
          helper.follow_user_button(them).should be_blank
        end
      end

      context "not following them" do
        before { us.stub(:following?) { false } }        

        it "shows a follow button" do
          helper.follow_user_button(them).should match(/class="button follow/i)
        end
      end

      context "following them" do
        before { us.stub(:following?) { true } }

        it "shows an unfollow button" do
          helper.follow_user_button(them).should match(/class="button unfollow/i)
        end
      end
    end

    context "not signed in" do
      before { helper.stub(:user_signed_in?) { false } }

      it "doesn't show the button" do
        helper.follow_user_button(them).should be_blank
      end
    end
  end
end
