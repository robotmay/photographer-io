$(document).ready ->
  photoGrid = $(".photo-grid")
  photoGrid.imagesLoaded ->
    photoGrid.trigger "reload:grid"

  photoGrid.on "reload:grid", ->
    photoGrid.find(".photo, .user-block").wookmark(wookmarkOptions)
