class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :set_layout
  helper_method :set_title, :hide_filters?

  before_filter do
    @categories = Rails.cache.fetch([:categories, :list], expires_in: 5.minutes) do
      Category.order("name ASC").load
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
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
end
