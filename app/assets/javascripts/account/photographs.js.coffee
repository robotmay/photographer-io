$(document).ready ->
  photoForm = $("form#photograph-uploader")
  if photoForm.length > 0
    photoForm.S3Uploader()

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

