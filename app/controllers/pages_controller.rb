class PagesController < ApplicationController
  respond_to :html

  def home
    @top_photos = Rails.cache.fetch([:home, :top_photos], expires_in: 10.minutes) do
      Photograph.landscape.recommended(current_user, 10)
    end

    respond_with @top_photos
  end
end
