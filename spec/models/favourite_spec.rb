require 'spec_helper'

describe Favourite do
  it { should belong_to(:user) }
  it { should belong_to(:photograph) }
end
