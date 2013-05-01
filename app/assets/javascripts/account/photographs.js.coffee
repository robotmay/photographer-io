#= require dropzone
Dropzone.autoDiscover = false

$(document).ready ->
  photoForm = $("form#new_photograph")
  if photoForm.length > 0
    dropzone = new Dropzone("form#new_photograph", {
      paramName: "photograph[image]"
      parallelUploads: 1
      maxFileSize: 100
      maxThumbnailFilesize: 3
      acceptParam: "image/jpg"
      init: ->
        photoForm.addClass("dropzone")
    })

    dropzone.on "sending", (file, xhr) ->
      $.rails.CSRFProtection(xhr)
