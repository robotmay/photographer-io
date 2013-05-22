$(document).ready ->
  thread = $(".comment-thread")
  comments = thread.find(".comments")

  eventLock = false

  thread.on "ajax:success", "#new_comment", (event, data, status, error) ->
    unless eventLock
      eventLock = true
      $(this).parents(".comment-thread").first().find("> .comments").prepend(data)
      $(this).find("textarea").val(null)
      eventLock = false

  thread.on "ajax:error", "#new_comment", (event, xhr, status, error) ->
    $(this).replaceWith(xhr.responseText)

$("body").on "click", "[data-toggle-reply]", (e) ->
  e.preventDefault()
  toOpen = $(this).parents(".comment").first().find("> .replies > [data-reply]")
  $("[data-reply]:visible").not(toOpen).hide()
  toOpen.toggle()
