require 'spec_helper'

describe Account::PhotographsController do
  let(:user) { User.make! }
  before { sign_in user }

  describe "PUT mass_update" do
    let(:mass_edit) { double(mass_edit_defaults.merge(mass_edit_attributes)) }
    let(:mass_edit_defaults) {{
      :user= => user,
      :action => ''
    }}
    let(:mass_edit_attributes) { {} }
    let!(:photograph) { Photograph.make!(user: user) }
    let(:photographs) { [photograph] }

    before { MassEdit.stub(:new) { mass_edit } }
    before { request.env['HTTP_REFERER'] = root_path }

    describe "collections" do
      let!(:collection) { Collection.make!(user: user) }
      let(:collections) { [collection] }
      let(:mass_edit_attributes) do
        {
          photograph_ids: photographs.map(&:id),
          collection_ids: collections.map(&:id),
          photographs: photographs,
          collections: collections,
          action: 'collections'
        }
      end

      it "is successful" do
        post :mass_update, mass_edit: mass_edit_attributes
        response.status.should eq(302)
      end

      it "calls #perform_mass_update" do
        subject.should_receive(:perform_mass_update)
        post :mass_update, mass_edit: mass_edit_attributes
      end

      it "calls #perform_collection_update" do
        subject.should_receive(:perform_collection_update)
        post :mass_update, mass_edit: mass_edit_attributes
      end

      it "updates photograph collections" do
        post :mass_update, mass_edit: mass_edit_attributes
        photograph.collections.should include(collection)
      end
    end
  end
end
