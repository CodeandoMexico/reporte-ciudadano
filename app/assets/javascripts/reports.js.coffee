$ ->
  $('.js-load_category_fields').change ->
    $.ajax(
      url: '/categories/load_category_fields'
      data: {
        id: $(@).val()
      }
    )

  if window.FileReader
    $('.js-image-preview').change (event) ->
      files = event.target.files[0]
      reader = new FileReader()
      reader.onload = ((theFile) ->
        return (e) ->
          $('.image_preview').html("<img src='#{e.target.result}' title='#{theFile.name}' width='99' height='88' />"))(files)
      reader.readAsDataURL(files)
