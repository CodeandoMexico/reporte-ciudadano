jQuery ->
  $('.js-sortable').sortable(
    revert: 100
    cursor: "move"
    opacity: 0.8
    update: (e, ui) ->
      container = ui.item.parents('.js-sortable')
      ids = $(container).sortable('serialize')
      post_url = $(container).data('url')

      $.post post_url, ids, (data, status) ->
        console.log ids
  ).disableSelection()

