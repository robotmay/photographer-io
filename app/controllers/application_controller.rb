class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :set_layout
  helper_method :set_title

  before_filter do
    @categories = Rails.cache.fetch([:categories, :list], expires_in: 5.minutes) do
      Category.order("name ASC").load
    end
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
end
