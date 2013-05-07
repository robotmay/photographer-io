class PagesController < ApplicationController
  respond_to :html

  def home
    @top_photos = Photograph.landscape.recommended(current_user, 10)
    respond_with @top_photos
  end
end
