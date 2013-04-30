module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in User.new(first_name: 'Test', last_name: 'User')
    end
  end
end
