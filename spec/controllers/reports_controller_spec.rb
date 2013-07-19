require 'spec_helper'

describe ReportsController do
  let(:user) { User.make! }
  let(:report) { Report.make }
  before { sign_in user }

  describe "GET new" do
    it "assigns a blank report" do
      get :new
      assigns(:report).should be_a(Report)
    end
  end

  describe "POST create" do
  
  end
end
