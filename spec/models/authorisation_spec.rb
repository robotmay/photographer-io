require 'spec_helper'

describe Authorisation do
  let(:authorisation) { Authorisation.make }

  it { should belong_to(:user) }

  [:user_id, :provider, :uid].each do |attr|
    it { should validate_presence_of(attr) }
  end

  it { should respond_to(:token) }
  it { should respond_to(:expires_at) }

  describe "callbacks" do
    context "initialize" do
      after(:each) { authorisation.run_callbacks(:initialize) }

      it "runs setup" do
        authorisation.should_receive(:setup)    
      end
    end
  end

  describe "#get_token" do
    pending "Should be a more general method"
  end

  describe "#profile" do
    pending
  end

  describe "#mention" do
    pending
  end

  describe "self.find_or_create_from_auth_hash" do
    pending
  end
end
