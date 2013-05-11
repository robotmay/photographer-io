$(document).ready ->
  miniStats = $("#mini-user-stats")

  viewsEl = miniStats.find(".views .number")
  recommendationsEl = miniStats.find(".recommendations .number")
  favouritesEl = miniStats.find(".favourites .number")

  userChannel.bind "stats_update", (data) ->
    console.log(data)
    viewsEl.text(data['views'])
    recommendationsEl.text(data['recommendations'])
    favouritesEl.text(data['favourites'])
