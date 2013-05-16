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
  description = image.siblings(".description")
  if image.length > 0
    image.on "resize:description", ->
      if description.length > 0
        description.innerWidth(image.width())
        if description.is(":hidden")
          description.fadeIn()

    $(".display").imagesLoaded ->
      image.trigger "resize:description"

    $(window).resize ->
      image.trigger "resize:description"
