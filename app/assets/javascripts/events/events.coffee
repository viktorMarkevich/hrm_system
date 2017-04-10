#= require events/templates/table
#= require events/templates/event
#= require events/templates/candidates_list

# coding 'utf-8'
$(document).ready ->
  $('.btn-dialog').click ->
    $('.candidates_list tbody').empty()
    $('.cand-list').hide()
    $('#dialog').modal('show')
    $('#dialog').removeClass('show_modal')



  show_event_modal = (params) ->
    $.get "/selected_day_events?will_begin_at=#{params}", (data) ->
      $('#event-dialog').modal('show')
      for events in data
        event_time = new Date(events.will_begin_at)
        month = (event_time.getMonth()+1 < 10 && '0' || '') + (event_time.getMonth()+1)
        event = JST["events/templates/event"]({
          name: events.name,
          vacancy: events.vacancy_name,
          candidate: events.candidate_name,
          hours: (event_time.getUTCHours() < 10 && '0' || '') + event_time.getUTCHours(),
          minutes: (event_time.getMinutes() < 10 && '0' || '') + event_time.getMinutes(),
          formated_date: ((event_time.getDate() < 10 && '0' || '') + event_time.getDate()) + '/' + month + '/' + event_time.getFullYear(),
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
    $('.events-table .events-body').empty()
    show_event_modal(params)

  $(document).on('click', "td a.event-badge", bindShowEvent)

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
        $('.candidates_list tbody').empty()
        $('.cand-list').hide()
        if current_time.getFullYear() == event_time.getFullYear() and current_time.getMonth() == event_time.getMonth()
          add_event(data, event_time)
        if $('#dialog').hasClass('show_modal')
          params = "#{event_time.getFullYear()}-#{(event_time.getMonth()+1 < 10 && '0' || '') + (event_time.getMonth()+1)}-#{(event_time.getDate() < 10 && '0' || '') + event_time.getDate()}"
          $('#dialog').removeClass('show_modal')
          show_event_modal(params)
    , 'JSON'
    ).fail( (data) ->
      resetForm(form)
      alertMessage(data, form)
    )

  add_event = (data, event_time) ->
    month = (event_time.getMonth()+1 < 10 && '0' || '') + (event_time.getMonth()+1);
    event = JST["events/templates/event"]({
              name: data.name,
              vacancy: data.vacancy_name,
              candidate: data.candidate_name,
              hours: (event_time.getUTCHours() < 10 && '0' || '') + event_time.getUTCHours(),
              minutes: (event_time.getMinutes() < 10 && '0' || '') + event_time.getMinutes(),
              formated_date: ((event_time.getDate() < 10 && '0' || '') + event_time.getDate()) + '/' + month + '/' + event_time.getFullYear(),
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
    formData.append('event[staff_relation_attributes][vacancy_id]', $('#editEvent #event_staff_relation_attributes_vacancy_id').val())
    formData.append('event[staff_relation_attributes[candidate_id]]', $('#editEvent #event_candidate').val())
    url = "events/#{p}"
    $.ajax
      url: url
      type: 'PUT'
      dataType: 'json'
      processData: false
      contentType: false
      data: formData
      success: (data) ->
        event_time = new Date(data.e.will_begin_at)
        month = (event_time.getMonth()+1 < 10 && '0' || '') + (event_time.getMonth()+1);
        hours = (event_time.getUTCHours() < 10 && '0' || '') + event_time.getUTCHours();
        minutes = (event_time.getMinutes() < 10 && '0' || '') + event_time.getMinutes();
        formated_date= ((event_time.getDate() < 10 && '0' || '') + event_time.getDate()) + '/' + month + '/' + event_time.getFullYear()
        $("tr.event#{data.e.id}>td.event_name>span.label").html(data.e.name)
        $("tr.event#{data.e.id}>td.event_will_begin_at").html('<span class="label label-primary">'+ "#{hours}:#{minutes }"+'</span>' + formated_date)
        $("tr.event#{data.e.id}>td.event_description").html(data.e.description)
        $("tr.event#{data.e.id}>td.event_vacancy").html(data.v.name)
        $("tr.event#{data.e.id}>td.event_candidate").html(data.c.name)
        $('#editEvent').modal('hide')


  format_date = (current_time) ->
    date = new Date(current_time)
    hours = (date.getHours() < 10 && '0' || '') + date.getHours();
    minutes = (date.getMinutes() < 10 && '0' || '') + date.getMinutes();
    month = (date.getMonth()+1 < 10 && '0' || '') + (date.getMonth()+1);
    day = (date.getDate() < 10 && '0' || '') + date.getDate();
    formated_date= date.getFullYear() + '/' + month + '/' + day
    data_day = "#{formated_date} #{hours}:#{minutes}"

  $('.edit-event').click (e) ->
    clear_table()
    p = $(e.currentTarget).data('eventid')
    $.ajax
      url:"/events/#{p}"
      type: 'get'
      success: (data) ->
        $('#event_name').val(data.e.name)
        $('#event_description').val(data.e.description)
        data_day = format_date(data.e.will_begin_at)
        $('#event_will_begin_at').val(data_day)
        $('#event_id').val(data.e.id)
        $('.candidates_list tbody').empty()
        $('.cand-list').show()
        $('#event_staff_relation_attributes_vacancy_id').val(data.v.id)
        if data.c.name.length > 0
          candidat = JST["events/templates/candidates_list"]({
            name: data.c.name,
            phone: data.c.phone,
            email: data.c.email
            id: data.c.id
          })
          $('.candidates_list tbody').append(candidat)
        $('#editEvent').modal('show')

  open_modal_at_day = (data) ->
    $('.candidates_list tbody').empty()
    $('.cand-list').hide()
    $('#dialog #event_will_begin_at').val(data)
    $('#dialog').addClass('show_modal')
    $('#event-dialog').data('day', data)
    $('#dialog').modal('show')

  $('.add_event').click ->
    $('#event-dialog').modal('hide')
    data_day = format_date($('#event-dialog').data('day'))
    open_modal_at_day(data_day)

  $('td.day').click ->

    if !$(this).hasClass('has-events') and  !$(this).hasClass('past')
      select_day =  $(this).children('span').data('selectedDay')
      current_time =  $(this).children('span').data('currentTime')
      select  = new Date(select_day)
      current  = new Date(current_time)
      if current.getDay() >= select.getDay() and current.getMonth() >= select.getMonth() and current.getFullYear()>= select.getFullYear()
        data_day= format_date(current_time)
        open_modal_at_day(data_day)
      else
        data_day= format_date(select_day)
        open_modal_at_day(data_day)

  add_candidate_to_table = (vacancy_id) ->
    $.get  "/v_candidates/#{vacancy_id}", (data) ->
      $('.candidates_list tbody').empty()
      $('.cand-list').show()
      for candidate in data.candidates
        candidat = JST["events/templates/candidates_list"]({
          name: candidate.name,
          phone: candidate.phone,
          email: candidate.email
          id: candidate.id
        })
        $('.candidates_list tbody').append(candidat)

      tr_count = $('.candidates_list tbody tr').length


  $('.form-group #event_staff_relation_attributes_vacancy_id').change ->
    vacancy_id = $(this).val()
    if vacancy_id
      add_candidate_to_table(vacancy_id)
    else
      $('.candidates_list tbody').empty()
      $('.cand-list').hide()


