require 'spec_helper'

describe Collection do
  it { should belong_to(:user) }
  it { should have_many(:collection_photographs) }
  it { should have_many(:photographs).through(:collection_photographs) }
  
  [:user_id, :name].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
