module Account
  class AuthorisationsController < AccountController
    respond_to :html

    def index
      @authorisations = current_user.authorisations
      respond_with @authorisations
    end

    def create
      @authorisation = current_user.authorisations.find_or_create_from_auth_hash(auth_hash)
      authorize! :manage, @authorisation

      if @authorisation.persisted?
        flash[:notice] = t("account.authorisations.create.succeeded")
        respond_with @authorisation do |f|
          f.html { redirect_to account_authorisations_path }
        end
      else
        flash[:alert] = t("account.authorisations.create.failed")
        respond_with @authorisation do |f|
          f.html { redirect_to account_authorisations_path }
        end
      end
    end

    private
    def auth_hash
      request.env['omniauth.auth']
    end
  end
end
