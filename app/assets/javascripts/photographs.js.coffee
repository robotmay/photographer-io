$(document).ready ->
  photoGrid = $(".photo-grid")
  photoGrid.imagesLoaded ->
    photoGrid.masonry
      itemSelector: 'li'
      columnWidth: (containerWidth) ->
        containerWidth / 5
      isResizable: true
