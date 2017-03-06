# coding 'utf-8'
$(document).ready ->
  $('.btn-dialog').click ->
    $('#dialog').modal('show')

  $('body').on 'keyup', '#event_name', ->
    val = $(this).val()
    if val.length > 0
      $('#staff_relation').hide(200)
    else
      $('#staff_relation').show(200)

  $('body').on 'change', '.staff_relation', ->
    val = $(this).find(':selected').data('status')
    if val != undefined
      $('#event_name').hide(200)

      status = $(".label_event_name").find('span.label')
      status.remove() if status.length > 0

      hidden = $('#hidden_event_name')
      hidden.remove() if hidden.length > 0

      $('.label_event_name').append(
        if val == 'Утвержден'
          "<span class='label label-success'>" + val + "</span>"
        else
          "<span class='label label-info'>" + val + "</span>"
      )
    else
      $('#event_name').show(200)

      status = $(".label_event_name").find('span.label')
      status.remove() if status.length > 0

      hidden = $('#hidden_event_name')
      hidden.remove() if hidden.length > 0
    return