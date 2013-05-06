class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :set_layout
  helper_method :set_title

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
