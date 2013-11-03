require 'spec_helper'

describe LicensesController do
  describe "GET show" do
    let(:license) { License.make }

    before { License.stub_chain(:friendly, :find) { license } }
    before { get :show, id: 1 }

    it "redirects to photographs path" do
      response.should redirect_to license_photographs_path(license)
    end
  end
end
