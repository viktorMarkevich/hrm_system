# coding 'utf-8'
$(document).ready ->

  $('body').on 'change', '.staff_relation', ->
    val = $(this).find(':selected').data('status')
    if val != undefined
      $('.name_field').find('.after_name_label').hide(200)

      status = $(".label_name").find('span.label')
      status.remove() if status.length > 0

      hidden = $('.name_field').find("input[type=hidden]")
      hidden.remove() if hidden.length > 0

      $('.label_name').append(
        if val == 'Утвержден'
          "<span class='label label-success'>" + val + "</span>"
        else
          "<span class='label label-info'>" + val + "</span>"
      )

      $('.name_field').append( "<input id='event_name' type='hidden' name='event[name]' value='"+val+"'>" )
    else
      $('.name_field').find('.after_name_label').show(200)

      status = $(".label_name").find('span.label')
      status.remove() if status.length > 0

      hidden = $('.name_field').find("input[type=hidden]")
      hidden.remove() if hidden.length > 0
    return


