require "spec_helper"

describe "pages" do
  describe "home", type: :feature do
    let(:photograph) { Photograph.make }
    before { photograph.stub(:id) { 1 } }
    before { Photograph.stub_chain(:landscape, :recommended) { [photograph] } }

    it "is accessible" do
      visit root_path
      page.should have_content I18n.t("home.title")
    end
  end
end
