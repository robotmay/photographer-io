require 'spec_helper'

describe CommentThread do
  it { should belong_to(:threadable) }
  it { should have_many(:comments) }
end
