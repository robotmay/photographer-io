class PagesController < ApplicationController
  respond_to :html

  def home
    @top_photos = Photograph.landscape.recommended(current_user, 5)
    respond_with @top_photos
  end
end
