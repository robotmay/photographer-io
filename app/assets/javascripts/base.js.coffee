$(document).foundation()
$(document).foundation('joyride', 'start')

I18n.fallbacks = true

window.calculateGridWidth = ->
  width = $(window).width()
  switch
    when width > 768
      flexibleWidth = '20%'
    when width > 500
      flexibleWidth = '50%'
    else
      flexibleWidth = '100%'

window.wookmarkOptions = (itemWidth) ->
  {
    align: 'center',
    container: $(".photo-grid"),
    flexibleWidth: itemWidth
  }

$(document).ready ->
  canvas = document.getElementById("blur")

  if canvas != null
    img = new Image()
    img.onload = ->
      canvasImage = new CanvasImage(canvas, this)
      canvasImage.blur(2)

    img.src = $(canvas).data('src')
