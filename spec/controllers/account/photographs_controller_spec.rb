require 'spec_helper'

describe Account::PhotographsController do
  let(:user) { User.make! }
  before { sign_in user }

  describe "PUT mass_update" do
    let!(:photograph) { Photograph.make!(user: user) }
    let(:photographs) { [photograph] }
    let(:mass_edit) { double(mass_edit_defaults.merge(mass_edit_attributes)) }
    let(:mass_edit_attributes) { {} }
    let(:mass_edit_defaults) do
      {
        :photograph_ids => photographs.map(&:id),
        :photographs => photographs,
        :user= => user,
        :action => ''
      }
    end

    let(:params) do
      {
        mass_edit: mass_edit_defaults.merge(mass_edit_attributes)
      }
    end

    before { MassEdit.stub(:new) { mass_edit } }
    before { request.env['HTTP_REFERER'] = root_path }

    describe "collections" do
      let!(:collection) { Collection.make!(user: user) }
      let(:collections) { [collection] }
      let(:mass_edit_attributes) do
        {
          collection_ids: collections.map(&:id),
          collections: collections,
          action: 'collections'
        }
      end

      it "redirects back" do
        post :mass_update, params
        response.status.should eq(302)
      end

      it "calls #perform_mass_update" do
        subject.should_receive(:perform_mass_update)
        post :mass_update, params
      end

      it "calls #perform_collection_update" do
        subject.should_receive(:perform_collection_update)
        post :mass_update, params
      end

      it "updates photograph collections" do
        post :mass_update, params
        photograph.collections.should include(collection)
      end
    end

    describe "delete" do
      let(:mass_edit_attributes) do
        { action: 'delete' }
      end

      it "calls #destroy" do
        photograph.should_receive(:destroy)
        post :mass_update, params
      end

      context "not our photo" do
        let(:not_our_photograph) { Photograph.make!(user: User.make!) }
        let(:mass_edit_attributes) do
          {
            action: 'delete',
            collection_ids: [1,2],
            photograph_ids: [not_our_photograph.id]
          }
        end

        it "isn't destroyed" do
          not_our_photograph.should_not_receive(:destroy)
          post :mass_update, params
        end
      end
    end

    describe "reprocess" do
      let(:mass_edit_attributes) do
        { action: "reprocess", photographs: double(stuck_processing: photographs) }
      end

      it "calls #create_sizes" do
        photograph.should_receive(:create_sizes)
        post :mass_update, params
      end
    end
  end
end
