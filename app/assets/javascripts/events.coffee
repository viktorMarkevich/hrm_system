# coding 'utf-8'
$(document).ready ->
  $('.btn-dialog').click ->
    $('#dialog').modal('show')

  $('.event_form').submit (e) ->
    current_time = new Date($('.calendar table').data('date'))
    e.preventDefault()
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
    , 'JSON'
    ).fail( (data) ->
      resetForm(form)
      alertMessage(data, form)
    )

  add_event = (data, event_time) ->
    month = event_time.getMonth() + 1
    vacancy = if data.vacancy_name is null then '------' else data.vacancy_name
    candidate = if data.candidate_name is null then '------' else data.candidate_name
    update_url = if $(data).update_path is undefined then '' else '<a class="glyphicon glyphicon-edit" data-remote="true" href="'+ $(data).update_path +'></a>'
    destroy_url =  if $(data).destroy_path is undefined then '' else '<a data-confirm="Вы уверены?" class="glyphicon glyphicon-remove" rel="nofollow" data-method="delete" href="'+ $(data).destroy_path +'"></a>'
    formated_date = event_time.getDate() + '/' + month + '/' + event_time.getFullYear()
    event = '<tr><td><span class="label label-default">' + data.name + '<span></td><td>' + vacancy + '</td><td>' +
            candidate + '</td><td><span class="label label-primary">' + event_time.getHours() + ':' +
            event_time.getMinutes() + '</span> ' + formated_date + '</td><td>' +
            data.description + '</td><td>' + update_url + ' ' + destroy_url + '</td></tr>'
    calendar_event = '<a class="event-badge" data-remote="true" href="/events?start_date=' +
                      event_time.getFullYear() + '-' + month + '-' + event_time.getDate() + '">1</a>'
    table = '<div class="future items-list"><table class="table table-bordered table-hover table-list"><thead><tr>' +
            '<th>Событие</th><th>На вакансию</th><th>С кем</th><th>Время события</th><th>Описание</th>' +
            '<th>Действия</th></tr></thead></table></div>'
    if $('.table-hover').length > 0
      $('.table-hover').append(event)
    else
      $('.events-list.future').append(table)
      $('.table-hover').append(event)
    event_day = event_time.getDate()
    event_day_td = $("td:not(.prev-month) span[data-day='#{event_day}']").parents('td')
    if event_day_td.hasClass('td-primary')
      current_count = event_day_td.find('a').text()
      count = parseInt(current_count) + 1
      event_day_td.find('a').text(count)
    else
      event_day_td.addClass('td-primary').append(calendar_event)

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