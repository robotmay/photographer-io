require 'spec_helper'

describe Recommendation do
  it { should belong_to(:photograph) }
  it { should belong_to(:user) }
  
  [:photograph_id, :user_id].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
