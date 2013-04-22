jQuery ->

  $('.image_container').click (e) ->
    $('#comment_image').click()

  $('#comment_image').change (event) ->
    files = event.target.files[0]
    reader = new FileReader()
    reader.onload = (file) ->
      $('.add_image').hide()
      $('#preview_image').attr('src', file.target.result).width('100').height('100').show()
    reader.readAsDataURL(files)


