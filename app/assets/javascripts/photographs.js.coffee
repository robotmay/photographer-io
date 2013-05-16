$(document).ready ->
  # Photo grid
  photoGrid = $(".photo-grid")
  photoGrid.imagesLoaded ->
    photoGrid.trigger "reload:grid"

  $(window).resize ->
    photoGrid.trigger "reload:grid"

  photoGrid.on "reload:grid", ->
    opts = wookmarkOptions(calculateGridWidth())
    photoGrid.find(".photo, .user-block").wookmark(opts)

  # Description size tweaking on photo show
  image = $(".display .image img")
  if image.length > 0
    image.siblings(".description").innerWidth(image.width())
