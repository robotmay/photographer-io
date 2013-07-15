require 'spec_helper'

describe "Users" do
  let(:user) { User.make! }

  describe "sign in", type: :feature do
    it "signs me in" do
      sign_in(user)
      page.should have_content "Signed in successfully."
    end
  end

  describe "sign out", type: :feature do
    it "signs me out" do
      sign_in(user)
      click_link "Sign out"
      page.should have_content "Signed out successfully."
    end
  end

  describe "delete account", type: :feature do
    it "deletes my account" do
      sign_in(user)
      visit "/account/edit"
      click_link "Delete Account"
      page.should have_content "Bye! Your account was successfully cancelled. We hope to see you again soon."
    end
  end

  describe "sign up", type: :feature do
    let(:user) { User.make }

    it "signs me up" do
      visit "/account/sign_up"
      within("#new_user") do
        fill_in "Username", with: user.username
        fill_in "Name", with: user.name
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password, match: :prefer_exact
        fill_in "Password confirmation", with: user.password, match: :prefer_exact
      end

      click_button "Create your account"
      page.should have_content "Welcome! You have signed up successfully."
    end
  end
end

def sign_in(user)
  visit "/account/sign_in"
  within("#new_user") do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
  end

  click_button "Sign in"
end

