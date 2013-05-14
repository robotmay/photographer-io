$(document).ready ->
  photoGrid = $(".photo-grid")
  photoGrid.imagesLoaded ->
    photoGrid.trigger "reload:grid"

  $(window).resize ->
    photoGrid.trigger "reload:grid"

  photoGrid.on "reload:grid", ->
    opts = wookmarkOptions(calculateGridWidth())
    photoGrid.find(".photo, .user-block").wookmark(opts)
