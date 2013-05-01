#= require dropzone
Dropzone.autoDiscover = false

$(document).ready ->
  photoForm = $("form#new_photograph")
  if photoForm.length > 0
    dropzone = new Dropzone("form#new_photograph", {
      paramName: "photograph[name]"
      parallelUploads: 1
      maxFileSize: 100
      maxThumbnailFilesize: 3
      init: ->
        photoForm.addClass("dropzone")
    })

    dropzone.on "sending", (file, xhr) ->
      $.rails.CSRFProtection(xhr)
