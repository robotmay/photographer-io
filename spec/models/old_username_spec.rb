require 'spec_helper'

describe OldUsername do
  it { should belong_to(:user) }

  [:user_id, :username].each do |attr|
    it { should validate_presence_of(attr) }
  end

  it { should validate_uniqueness_of(:username) }
end
