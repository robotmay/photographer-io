require 'spec_helper'

describe Photograph do
  it { should belong_to(:user) }
  it { should have_one(:metadata) }
  it { should have_many(:collection_photographs) }
  it { should have_many(:collections).through(:collection_photographs) }
  it { should belong_to(:license) }

  [:user_id, :image].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
