require 'spec_helper'

describe User do
  it { should have_many(:photographs) }
  it { should have_many(:collections) }
  it { should have_many(:recommendations) }
  it { should have_many(:favourites) }
  it { should have_many(:favourite_photographs).through(:favourites) }
end
