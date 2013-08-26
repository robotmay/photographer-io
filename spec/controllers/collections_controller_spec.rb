require 'spec_helper'

describe CollectionsController do
  let(:user) { User.make! }
  before { sign_in user }

  describe "GET show" do
    let(:collection) { Collection.make(visible: visibility) }
    let(:photographs) { [Photograph.make] }

    before do
      collection.stub(:id) { 1 }
      collection.stub_chain(:photographs, :visible, :page) { photographs }
      Collection.stub(:find) { collection }
    end

    context "public collection" do
      let(:visibility) { true }

      it "renders the view" do
        get :show, id: 1
        response.should render_template(:show)
      end

      it "assigns @collection" do
        get :show, id: 1
        assigns(:collection).should eq(collection)
      end

      it "assigns @photographs" do
        get :show, id: 1
        assigns(:photographs).should eq(photographs)
      end

      it "increments the views counter" do
        collection.views.should_receive(:increment)
        get :show, id: 1
      end
    end

    context "private collection" do
      let(:visibility) { false }

      it "raises an error" do
        get :show, id: 1
        response.should redirect_to(root_url)
      end
    end
  end
end
