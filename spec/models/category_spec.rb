require 'spec_helper'

describe Category do
  it { has_many(:photographs) }
end
