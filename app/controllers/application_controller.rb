class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :set_layout
  helper_method :set_title, :hide_filters?, :sharing_mode

  attr_accessor :sharing_mode

  before_filter :fetch_categories
  def fetch_categories
    @categories = Rails.cache.fetch([I18n.locale, :categories, :list], expires_in: 5.minutes) do
      Category.order("name ASC").load
    end

  # Handle a cache failure here, as it will impact entire site
  rescue Exception
    @categories = Category.order("name ASC")
  end

  before_filter :fetch_licenses
  def fetch_licenses
    @licenses = Rails.cache.fetch([I18n.locale, :licenses, :list], expires_in: 5.minutes) do
      License.order("id ASC").load
    end

  # Handle a cache failure here, as it will impact entire site
  rescue Exception
    @licenses = License.order("id ASC")
  end

  before_filter :google_analytics_identification
  def google_analytics_identification
    if $gabba.present?
      $gabba.identify_user(cookies[:__utma], cookies[:__utmz])
    end
  end

  before_filter :set_locale
  def set_locale
    I18n.locale = params[:locale] || (user_signed_in? ? current_user.locale : I18n.default_locale)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def default_url_options(opts = {})
    opts.merge({
      locale: I18n.locale
    })
  end

  protected
  def set_layout
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def set_title(title)
    unless title.nil?
      @title = title
    end
  end

  def session_id
    request.session_options[:id]
  end

  def recently_viewed_user_ids
    Redis::List.new("#{session_id}/recently_viewed_user_ids", maxlength: 10)
  end

  def hide_filters?
    @hide_filters ||= false
  end

  def hide_filters!
    @hide_filters = true
  end

  def enable_sharing_mode
    self.sharing_mode = true
  end
end
