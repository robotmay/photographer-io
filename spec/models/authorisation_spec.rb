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
    context 'when provider is not google_oauth2' do
      it 'returns nil' do
        authorisation.profile.should be_nil
      end
    end
    context 'when provider is google_oauth2' do
      it 'returns profile' do
        authorisation.provider = "google_oauth2"
        authorisation.profile.should == $google_plus.person
      end
    end
  end

  describe "#mention" do
    url = "http://www.example.com/"

    context 'when provider is google_oauth2' do
      it 'returns true' do
        authorisation.provider = "google_oauth2"
        authorisation.mention(url).should be_true
      end
    end

    context 'when provider is not google_oauth2' do
      it 'returns nil' do
        authorisation.provider = "linkedin_oauth"
        authorisation.mention(url).should be_nil
      end
    end
  end

  describe ".find_or_create_from_auth_hash" do
    let(:auth_hash) {
                      { 'provider' => "photographre",
                        'user_id' => 1,
                        'uid' => '1',
                        'info' => {:key => 'Rob is cool'},
                        'credentials' => {:key => 'true'},
                        'extra' => {:key => 'is secret'}
                      }
                    }

    context 'when there is a persistent authorisation' do
      it 'it updates and returns auth' do
        auth = Authorisation.find_or_create_from_auth_hash(auth_hash)
        auth.update_attributes(auth_hash)
        auth.provider.should == "photographre"
        auth.uid.should == "1"
        auth.info.should == {:key => 'Rob is cool'}
        auth.credentials.should == {:key => 'true'}
        auth.extra.should == {:key => 'is secret'}
      end
    end

    context 'when there is no persistent authorisation' do
      it 'it finds or creates, and returns auth' do
        auth2 = Authorisation.find_or_create_from_auth_hash(auth_hash)
        auth2.provider.should == "photographre"
        auth2.uid.should == "1"
        auth2.info.should be_nil
        auth2.credentials.should be_nil
        auth2.extra.should be_nil
      end
    end
  end
end
