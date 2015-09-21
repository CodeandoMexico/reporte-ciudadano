$(document).on 'ready page:load', ->
  # The body element has the controller and action name as class attribute
  current_controller_and_action = $("body").attr('class')

  $tabs = $('.menu a')
  # Activate the tab for the current controller and action
  $tabs.filter("[class='#{current_controller_and_action}']").addClass('active')
  # On click change active tab
  $tabs.click ->
    $tabs.removeClass 'active'
    $(@).addClass 'active'

#  $('#service_request_status_id').change ->
#    status_id = $(@).val()
#    service_id = $(@).data('service-id')
#    $.ajax(
#      url: "/admins/services/#{service_id}/messages"
#      data:
#        status_id: status_id
#      type: 'GET'
#    )

  $(window).resize ->
    $("#main_width").html $(window).width()

  setTimeout ->
    hideFlashMessages()
  ,4000

  hideFlashMessages = ->
    $(".alert").fadeOut('slow')

  $('.js-tabs a').on "click", (e)->
    e.preventDefault()
    $(this).tab('show')

  $(".js-tooltip").tooltip()
