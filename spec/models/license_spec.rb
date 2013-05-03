require 'spec_helper'

describe License do
  it { should have_many(:photographs) }
end
