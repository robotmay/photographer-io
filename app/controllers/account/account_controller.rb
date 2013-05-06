module Account
  class AccountController < ApplicationController
    before_filter :authenticate_user!
    layout 'account'

    def dashboard

    end
  end
end
