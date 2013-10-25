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

  $('body').on 'click', '.js-form-submitter', ->
    $(@).closest('form').submit()
    $(@).next('.js-save-box').removeClass('hide')

  $('.edit_setting').bind('ajax:success', (e, data, status, xhr) ->
    setTimeout (->
      $('.js-save-box','.edit_setting' ).addClass('hide')
    ), 500
  ).bind 'ajax:error', (e, xhr, status, error) ->
    $('.js-save-box', @).addClass('hide')

