$(document).ready ->
  miniStats = $("#mini-user-stats")

  if miniStats.length > 0
    viewsEl = miniStats.find(".views .number")
    followersEl = miniStats.find(".followers .number")
    recommendationsEl = miniStats.find(".recommendations .number")
    favouritesEl = miniStats.find(".favourites .number")

    pubnub.events.bind 'stats_update', (data) ->
      viewsEl.changeStat(data.views)
      followersEl.changeStat(data.followers)
      recommendationsEl.changeStat(data.recommendations)
      favouritesEl.changeStat(data.favourites)

$.fn.changeStat = (newValue) ->
  val = newValue.toString()
  if this.text() != val
    this.text(val)
    this.addClass("active")
    setTimeout (=>
      this.removeClass("active")
    ), 500
