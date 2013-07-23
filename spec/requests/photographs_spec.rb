require 'spec_helper'

describe "Photographs" do
  let(:user) { User.make! }
  let!(:photograph) { Photograph.make!(user: user) }
  let!(:metadata) { Metadata.make!(photograph: photograph) }

  describe "show", type: :feature do
    context "public" do
      before { photograph.stub(:visible?) { true } }
      before { Photograph.stub(:find) { photograph } }

      it "displays the photo title" do
        visit photograph_path(photograph)
        page.should have_content(photograph.title)
      end
    end
  end
end
