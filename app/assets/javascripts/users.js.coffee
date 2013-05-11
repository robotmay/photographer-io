$(document).ready ->
  miniStats = $("#mini-user-stats")

  viewsEl = miniStats.find(".views .number")
  recommendationsEl = miniStats.find(".recommendations .number")
  favouritesEl = miniStats.find(".favourites .number")

  userChannel.bind "stats_update", (data) ->
    viewsEl.changeStat(data['views'])
    recommendationsEl.changeStat(data['recommendations'])
    favouritesEl.changeStat(data['favourites'])

$.fn.changeStat = (newValue) ->
  val = newValue.toString()
  if this.text() != val
    this.text(val)
    this.addClass("active")
    setTimeout (=>
      this.removeClass("active")
    ), 500
