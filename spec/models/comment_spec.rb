require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:comment_thread) }
  it { should have_many(:notifications) }
end
