$(document).ready ->
  thread = $(".comment-thread")
  comments = thread.find(".comments")

  thread.on "ajax:success", "#new_comment", (event, data, status, error) ->
    $(this).parents(".comment-thread").first().find(".comments").prepend(data)
    $(this).find("textarea").val(null)

  thread.on "ajax:error", "#new_comment", (event, xhr, status, error) ->
    $(this).replaceWith(xhr.responseText)
