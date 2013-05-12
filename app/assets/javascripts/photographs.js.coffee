$(document).ready ->
  photoGrid = $(".photo-grid")
  photoGrid.imagesLoaded ->
    photoGrid.find(".photo").wookmark(wookmarkOptions)
