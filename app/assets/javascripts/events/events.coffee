#= require events/templates/table
#= require events/templates/event

# coding 'utf-8'
$(document).ready ->
  $('.btn-dialog').click ->
    $('#dialog').modal('show')


  show_event_modal = (params) ->
    $.get "/selected_day_events?will_begin_at=#{params}", (data) ->
      $('#event-dialog').modal('show')
      $('.events-table tbody').remove()
      for events in data
        event_time = new Date(events.will_begin_at)
        month = event_time.getMonth() + 1
        event = JST["events/templates/event"]({
          name: events.name,
          vacancy: events.vacancy_name,
          candidate: events.candidate_name,
          hours: event_time.getHours(),
          minutes: event_time.getMinutes(),
          formated_date: event_time.getDate() + '/' + month + '/' + event_time.getFullYear(),
          description: events.description,
          update_url: events.update_path,
          destroy_url: events.destroy_path
        })
        $('.events-table').append(event)

  bindShowEvent = (e) ->
    e.preventDefault()
    selected_day = moment($('.calendar-table').data('date')).date($(this).parents('td').find('span').text())
    params = new Date(selected_day)
    $('#event-dialog').data('day', params)
    show_event_modal(params)
  $(document).on('click', "td a", bindShowEvent)

  $('.event_form').submit (e) ->
    e.preventDefault()
    current_time = new Date($('.calendar-table').data('date'))
    url = $(this).attr('action')
    form = $(this)
    $.post(
      url,
      $(this).serialize(),
      (data) ->
        event_time = new Date(data.will_begin_at)
        resetForm(form)
        $('#dialog').modal('hide')
        if current_time.getFullYear() == event_time.getFullYear() and current_time.getMonth() == event_time.getMonth()
          add_event(data, event_time)
          console.log $('#dialog').hasClass('show_modal')
        if $('#dialog').hasClass('show_modal')
          console.log $('#dialog').hasClass('show_modal')
          params = event_time
          $('#dialog').removeClass('show_modal')
          show_event_modal(params)
    , 'JSON'
    ).fail( (data) ->
      resetForm(form)
      alertMessage(data, form)
    )

  add_event = (data, event_time) ->
    month = event_time.getMonth() + 1
    event = JST["events/templates/event"]({
              name: data.name,
              vacancy: data.vacancy_name,
              candidate: data.candidate_name,
              hours: event_time.getHours(),
              minutes: event_time.getMinutes(),
              formated_date: event_time.getDate() + '/' + month + '/' + event_time.getFullYear(),
              description: data.description,
              update_url: data.update_path,
              destroy_url: data.destroy_path
            })
    if $('.table-hover').length > 0
      $('.table-hover').append(event)
    else
      $('.events-list.future').append(JST["events/templates/table"]({}))
      $('.table-hover').append(event)
    event_day = event_time.getDate()
    event_day_td = $("td:not(.prev-month) span[data-day='#{event_day}']:first").parents('td')
    if event_day_td.hasClass('td-primary')
      current_count = event_day_td.find('a').text()
      count = parseInt(current_count) + 1
      event_day_td.find('a').text(count)
    else
      event_day_td.addClass('td-primary').append('<a class="event-badge">1</a>')

  alertMessage = (data, container) ->
    alert = "<div class='alert alert-danger'>#{ data.responseJSON.errors.join('<br>') }</div>"
    $(alert).insertBefore(container)

  resetForm = (form) ->
    form.trigger('reset')
    form.find('input.btn.btn-default').removeAttr('disabled')

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

  $('#datetimepicker2').datetimepicker({
    defaultDate: if moment($('.calendar-table').data('date')).add(1, 'seconds').toDate() > moment()
                    moment($('.calendar-table').data('date')).add(1, 'seconds').toDate()
                 else moment().add(1, 'seconds').toDate(),
    minDate: moment()
  })


  clear_table = (e) ->
    b= $('.table-list tbody').find('tr').length
    if b < 1
      $('.table-list').remove()
      $('.tip.description_count').html('Список предстоящих событий за Март пуст')

  $('.remove-event').click (e) ->
    p = $(e.currentTarget).data('eventid')
    url = "events/#{p}"
    $.ajax
      url: url
      type: 'DELETE'
      dataType: 'json'
      success: (data) ->
        $(e.currentTarget).parents('tr').remove()
        clear_table()



  $('#editEvent .btn-default').click (e) ->
    p = $('#editEvent #event_id').val()
    formData = new FormData()
    formData.append('event[name]', $('#editEvent #event_name').val())
    formData.append('event[description]', $('#editEvent #event_description').val())
    formData.append('event[will_begin_at]', $('#editEvent #event_will_begin_at').val())
    url = "events/#{p}"
    $.ajax
      url: url
      type: 'PUT'
      dataType: 'json'
      processData: false
      contentType: false
      data: formData
      success: (data) ->
        event_time = new Date(data.will_begin_at)
        month = event_time.getMonth() + 1
        hours= event_time.getHours()
        minutes= event_time.getMinutes()
        formated_date= event_time.getDate() + '/' + month + '/' + event_time.getFullYear()
        $("tr.event#{data.id}>td.event_name>span.label").html(data.name)
        $("tr.event#{data.id}>td.event_will_begin_at").html('<span class="label label-primary">'+ "#{hours}:#{minutes }"+'</span>' + formated_date)
        $("tr.event#{data.id}>td.event_description").html(data.description)
        $('#editEvent').modal('hide')

  $('.edit-event').click (e) ->
    clear_table()
    p = $(e.currentTarget).data('eventid')
    $.ajax
      url:"/events/#{p}"
      type: 'get'
      success: (data) ->
        $('#event_name').val(data.name)
        $('#event_description').val(data.description)
        $('#event_will_begin_at').val(data.will_begin_at)
        $('#event_id').val(data.id)
        $('#editEvent').modal('show')

  open_modal_at_day = (data) ->
    $('#dialog #event_will_begin_at').val(data)
    $('#dialog').addClass('show_modal')
    $('#dialog').modal('show')

  $('.add_event').click ->
    day_date = $('#event-dialog').data('day')
    hours= day_date.getHours() + 9
    minutes= day_date.getMinutes()
    month = day_date.getMonth() + 1
    formated_date= day_date.getFullYear() + '/' + month + '/' + day_date.getDate()
    data = "#{formated_date} 0#{hours}:0#{minutes}"
    $('#event-dialog').modal('hide')
    open_modal_at_day(data)

  $('td.day').click ->
    if !$(this).hasClass('td-primary')
      console.log 'sosi'
      console.log $(this).children('span').data()
      select_day =  $(this).children('span').data('selectedDay')
      console.log select_day
      current_time =  $(this).children('span').data('currentTime')
      console.log current_time

      if current_time >= select_day
        console.log current_time
        day_date = new Date(current_time)
        hours= day_date.getHours()
        minutes= day_date.getMinutes()+1
        month = day_date.getMonth() + 1
        formated_date= day_date.getFullYear() + '/' + month + '/' + day_date.getDate()
        data = "#{formated_date} #{hours}:#{minutes}"
      else
        console.log select_day
        day_date = new Date(select_day)
        console.log day_date
        hours= day_date.getHours()
        minutes= day_date.getMinutes()
        month = day_date.getMonth() + 1
        formated_date= day_date.getFullYear() + '/' + month + '/' + day_date.getDate()
        data = "#{formated_date} #{hours}:#{minutes}"
      open_modal_at_day(data)