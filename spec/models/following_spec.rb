require 'spec_helper'

describe Following do
  it { should belong_to(:followee) }
  it { should belong_to(:follower) }

  [:followee_id, :follower_id].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "callbacks" do
    let(:following) { Following.make(followee: followee, follower: follower) }
    let(:followee) { User.make }
    let(:follower) { User.make }
    let(:counter) { double("counter", increment: true, decrement: true) }

    before do
      following.stub(:persisted?) { true }
      following.stub(:notify) { true }
      followee.stub(:followers_count) { counter }
      followee.stub(:push_stats) { true }
    end

    context "create" do
      after(:each) { following.run_callbacks(:create) }

      it "increments user stats" do
        followee.followers_count.should_receive(:increment)  
      end

      it "pushes the new stats" do
        followee.should_receive(:push_stats)
      end
    end

    context "destroy" do
      after(:each) { following.run_callbacks(:destroy) }

      it "decrements user stats" do
        followee.followers_count.should_receive(:decrement)  
      end

      it "pushes the new stats" do
        followee.should_receive(:push_stats)
      end
    end
  end
end
