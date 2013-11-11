$ ->
  $("abbr.timeago").timeago()

  $('.datepicker').datepicker({
    dateFormat: 'yy-mm-dd'
  })

  $('.js-load_service_fields').change ->
    $.ajax(
      url: '/services/load_service_fields'
      data: {
        id: $(@).val()
      }
    )

  $('.blocked').click (e) ->
    e.preventDefault()
    receivedMessage = $(@).data('message')
    if receivedMessage?
      alert receivedMessage
    else
      alert 'Es necesario que te registres en el sistema para realizar esta operación.'

  if window.FileReader
    $('.js-image-preview').change (event) ->
      files = event.target.files[0]
      reader = new FileReader()
      reader.onload = ((theFile) ->
        return (e) ->
          $('.image_preview').html("<img src='#{e.target.result}' title='#{theFile.name}' width='99' height='88' />"))(files)
      reader.readAsDataURL(files)
  
  $(".sortable_table").tablesorter(
    cssHeader: 'table-header'
    sortList: [[0,0]]
  )

  $('.sortable_table .table-header').click ->
    $('.table-header').find('i').removeClass('icon-chevron-up').addClass('icon-chevron-down')
    $(@).find('.icon-chevron-down').removeClass('icon-chevron-down').addClass('icon-chevron-up')
    if $(@).hasClass('headerSortUp')
      $(@).find('.icon-chevron-up').removeClass('icon-chevron-up').addClass('icon-chevron-down')
