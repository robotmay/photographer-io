#= require dropzone
Dropzone.autoDiscover = false

$(document).ready ->
  photoForm = $("form#new_photograph")
  if photoForm.length > 0
    dropzone = new Dropzone("form#new_photograph", {
      paramName: "photograph[image]"
      parallelUploads: 1
      maxFileSize: 100
      maxThumbnailFilesize: 2
      acceptParam: "image/jpg"
      init: ->
        photoForm.addClass("dropzone")
        photoForm.find("fieldset").hide()
    })

    dropzone.on "sending", (file, xhr) ->
      $.rails.CSRFProtection(xhr)

    dropzone.on "success", (file) ->
      if dropzone.filesQueue.length == 0
        location.reload()
      else
        setTimeout(->
          dropzone.removeFile(file)
        , 2000)

