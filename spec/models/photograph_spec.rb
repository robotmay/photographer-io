require 'spec_helper'

describe Photograph do
  it { should belong_to(:user) }
  it { should have_one(:metadata) }

  [:user_id, :image].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
