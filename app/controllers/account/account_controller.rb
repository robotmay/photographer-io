module Account
  class AccountController < ApplicationController
    before_filter :authenticate_user!
    layout 'account'

    def dashboard
      @stories = current_user.stories.order("created_at DESC").page(params[:page])
    end
  end
end
