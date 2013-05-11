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

    originalHeight = 0

    dropzone.on "dragover", (event) ->
      unless originalHeight > 0
        originalHeight = $(dropzone.element).height()
      $(dropzone.element).height(200)

    dropzone.on "dragleave", (event) ->
      $(dropzone.element).height(originalHeight)

    dropzone.on "sending", (file, xhr) ->
      $.rails.CSRFProtection(xhr)

    dropzone.on "success", (file) ->
      if dropzone.filesQueue.length == 0
        location.reload()
      else
        setTimeout(->
          dropzone.removeFile(file)
        , 2000)

  massEditForm = $("form#new_mass_edit")
  if massEditForm.length > 0
    massEditForm.data('edit-mode', false)

    massEditForm.find("li.photo input[type = 'checkbox']").prop("checked", false)

    massEditForm.on "click", "#toggle-edit-mode", (e) ->
      e.preventDefault()
      e.stopPropagation()

      $(this).toggleClass("alert")
      $(this).parents(".sub-nav").find(".button").not(this).toggleClass("disabled")
      massEditForm.toggleClass("edit-mode")
      massEditForm.data('edit_mode', !(massEditForm.data('edit_mode')))

    massEditForm.on "click", ".button.disabled", (e) ->
      e.preventDefault()
      e.stopPropagation()

    massEditForm.on "click", "li.photo a", (e) ->
      if massEditForm.data('edit_mode')
        e.preventDefault()
        e.stopPropagation()
        
        li = $(this).parent()
        checkbox = li.find("input[type = 'checkbox']")
        if checkbox.prop("checked")
          checkbox.prop("checked", false)
          li.removeClass("active")
        else
          checkbox.prop("checked", true)
          li.addClass("active")

