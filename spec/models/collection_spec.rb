require 'spec_helper'

describe Collection do
  it { should belong_to(:user) }
  
  [:user_id, :name].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
