$(document).ready ->
  thread = $(".comment-thread")
  comments = thread.find(".comments")

  eventLock = false

  thread.on "ajax:success", "#new_comment", (event, data, status, error) ->
    unless eventLock
      eventLock = true
      el = $(this).parents(".comment-thread").first().find("> .comments")
      el.find(".none").hide()
      el.prepend(data)
      $(this).find("textarea").val(null)
      eventLock = false

  thread.on "ajax:error", "#new_comment", (event, xhr, status, error) ->
    $(this).replaceWith(xhr.responseText)

  # Publishing/unpublishing
  comments.on "ajax:success", ".toggle", (event, data, status, error) ->
    unless eventLock
      eventLock = true
      $(this).toggleClass("published success unpublished secondary")
      $(this).parents(".comment").first().find("> .main footer .status").toggleClass("hidden")
      $(this).blur() # force remove focus to fix bug
      eventLock = false

# Reply collapsing
$("body").on "click", "[data-toggle-reply]", (e) ->
  e.preventDefault()
  toOpen = $(this).parents(".comment").first().find("> .replies > [data-reply]")
  $("[data-reply]:visible").not(toOpen).hide()
  toOpen.toggle()
