$ ->
  $('.js-load_category_fields').change ->
    $.ajax(
      url: '/categories/load_category_fields'
      data: {
        id: $(@).val()
      }
    )
