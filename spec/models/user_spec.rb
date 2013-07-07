require 'spec_helper'

describe User do
  it { should have_many(:photographs) }
  it { should have_many(:collections) }
  it { should have_many(:recommendations) }
  it { should have_many(:favourites) }
  it { should have_many(:favourite_photographs).through(:favourites) }
  it { should have_many(:received_favourites).through(:photographs) }
  it { should have_many(:followee_followings) }
  it { should have_many(:followers).through(:followee_followings) }
  it { should have_many(:follower_followings) }
  it { should have_many(:followees).through(:follower_followings) }
  it { should have_many(:followee_photographs).through(:followees) }
  it { should have_many(:invitations) }
  it { should have_many(:comment_threads) }
  it { should have_many(:comments) }
  it { should have_many(:notifications) }
  it { should have_many(:authorisations) }
  it { should have_many(:old_usernames) }
end
