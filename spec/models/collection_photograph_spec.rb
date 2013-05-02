require 'spec_helper'

describe CollectionPhotograph do
  it { should belong_to(:collection) }
  it { should belong_to(:photograph) }
end
