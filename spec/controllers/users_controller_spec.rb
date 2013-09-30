require 'spec_helper'

describe UsersController do

  before :each do
    @request.env['HTTPS'] = 'on'
    controller.stub(:require_admin)
  end

  describe 'GET #show' do
    context 'user exists' do
      it 'finds a user object' do
        User.should_receive(:find_by_id_or_username).with('10').and_return('username')
        get(:show, :id => 10)
        assigns(:user).should == 'username'
      end
    end
  end
end
