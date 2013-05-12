$(document).ready ->
  photoGrid = $(".photo-grid")
  photoGrid.imagesLoaded ->
    photoGrid.find(".photo, .user-block").wookmark(wookmarkOptions)
