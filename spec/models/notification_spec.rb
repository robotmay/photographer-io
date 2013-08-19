require 'spec_helper'

describe Notification do
  it { should belong_to(:notifiable) }
  it { should have_many(:stories) }

  describe "after create" do
    it "creates a story" do
      pending
    end
  end
end
