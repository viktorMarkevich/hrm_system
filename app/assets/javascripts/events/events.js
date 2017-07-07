//= require events/templates/table
//= require events/templates/event
//= require events/templates/candidates_list

$(document).ready(function() {
  var add_candidate_to_table, add_event, alertMessage, bindShowEvent, clear_table, format_date, open_modal_at_day, resetForm, show_event_modal;
  $('.btn-dialog').click(function() {
    $('.candidates_list tbody').empty();
    $('.cand-list').hide();
    $('#dialog').modal('show');
    return $('#dialog').removeClass('show_modal');
  });
  show_event_modal = function(params) {
    return $.get("/selected_day_events?will_begin_at=" + params, function(data) {
      var event, event_time, events, i, len, month, results;
      $('#event-dialog').modal('show');
      $('.events-table .events-body').empty();
      results = [];
      for (i = 0, len = data.length; i < len; i++) {
        events = data[i];
        event_time = new Date(events.will_begin_at);
        month = (event_time.getMonth() + 1 < 10 && '0' || '') + (event_time.getMonth() + 1);
        event = JST['events/templates/event']({
          name: events.name,
          vacancy: events.vacancy_name,
          candidate: events.candidate_name,
          hours: (event_time.getUTCHours() < 10 && '0' || '') + event_time.getUTCHours(),
          minutes: (event_time.getMinutes() < 10 && '0' || '') + event_time.getMinutes(),
          formated_date: ((event_time.getDate() < 10 && '0' || '') + event_time.getDate()) + '/' + month + '/' + event_time.getFullYear(),
          description: events.description,
          update_url: events.update_path,
          destroy_url: events.destroy_path
        });
        results.push($('.events-table').append(event));
      }
      return results;
    });
  };
  bindShowEvent = function(e) {
    var params, selected_day;
    e.preventDefault();
    selected_day = moment($('.calendar-table').data('date')).date($(this).parents('td').find('span').text());
    params = new Date(selected_day);
    $('#event-dialog').data('day', params);
    $('.events-table .events-body').empty();
    return show_event_modal(params);
  };
  $(document).on('click', 'td a.event-badge', bindShowEvent);
  resetForm = function(form) {
    form.trigger('reset');
    return form.find('input.btn.btn-default').removeAttr('disabled');
  };
  add_event = function(data, event_time) {
    var count, current_count, event, event_day, event_day_td, month;
    month = (event_time.getMonth() + 1 < 10 && '0' || '') + (event_time.getMonth() + 1);
    event = JST['events/templates/event']({
      name: data.name,
      vacancy: data.vacancy_name,
      candidate: data.candidate_name,
      hours: (event_time.getUTCHours() < 10 && '0' || '') + event_time.getUTCHours(),
      minutes: (event_time.getMinutes() < 10 && '0' || '') + event_time.getMinutes(),
      formated_date: ((event_time.getDate() < 10 && '0' || '') + event_time.getDate()) + '/' + month + '/' + event_time.getFullYear(),
      update_url: data.update_path,
      destroy_url: data.destroy_path
    });
    if ($('.table-hover').length > 0) {
      $('.items-list .table-hover tbody').append(event);
    } else {
      $('.events-list.future').append(JST['events/templates/table']({}));
      $('.table-hover').append(event);
    }
    event_day = event_time.getDate();
    event_day_td = $("td:not(.prev-month) span[data-day='" + event_day + "']:first").parents('td');
    if (event_day_td.hasClass('has-events')) {
      current_count = event_day_td.find('a').text();
      count = parseInt(current_count) + 1;
      return event_day_td.find('a').text(count);
    } else {
      return event_day_td.addClass('has-events').append('<a class="event-badge">1</a>');
    }
  };
  $('.event_form').submit(function(e) {
    var current_time, form, url;
    e.preventDefault();
    current_time = new Date($('#events_calendar').data('date'));
    url = $(this).attr('action');
    form = $(this);
    return $.post(url, $(this).serialize(), function(data) {
      var event_time, params;
      event_time = new Date(data.will_begin_at);
      resetForm(form);
      $('#dialog').modal('hide');
      $('.candidates_list tbody').empty();
      $('.cand-list').hide();
      if (current_time.getFullYear() === event_time.getFullYear() && current_time.getMonth() === event_time.getMonth()) {
        add_event(data, event_time);
        if ($('#dialog').hasClass('show_modal')) {
          params = (event_time.getFullYear()) + "-" + ((event_time.getMonth() + 1 < 10 && '0' || '') + (event_time.getMonth() + 1)) + "-" + ((event_time.getDate() < 10 && '0' || '') + event_time.getDate());
          show_event_modal(params);
          return $('#dialog').removeClass('show_modal');
        }
      }
    }, 'JSON').fail(function(data) {
      resetForm(form);
      return alertMessage(data, form);
    });
  });
  alertMessage = function(data, container) {
    var alert;
    alert = "<div class='alert alert-danger'>" + (data.responseJSON.errors.join('<br>')) + "</div>";
    return $(alert).insertBefore(container);
  };
  $('body').on('keyup', '#event_name', function() {
    var val;
    val = $(this).val();
    if (val.length > 0) {
      return $('#staff_relation').hide(200);
    } else {
      return $('#staff_relation').show(200);
    }
  });
  $('body').on('change', '.staff_relation', function() {
    var hidden, status, val;
    val = $(this).find(':selected').data('status');
    if (val !== void 0) {
      $('#event_name').hide(200);
      status = $(".label_event_name").find('span.label');
      if (status.length > 0) {
        status.remove();
      }
      hidden = $('#hidden_event_name');
      if (hidden.length > 0) {
        hidden.remove();
      }
      $('.label_event_name').append(val === 'Утвержден' ? "<span class='label label-success'>" + val + "</span>" : "<span class='label label-info'>" + val + "</span>");
    } else {
      $('#event_name').show(200);
      status = $(".label_event_name").find('span.label');
      if (status.length > 0) {
        status.remove();
      }
      hidden = $('#hidden_event_name');
      if (hidden.length > 0) {
        hidden.remove();
      }
    }
  });
  $('#datetimepicker2').datetimepicker({
    defaultDate: moment($('.calendar-table').data('date')).add(1, 'seconds').toDate() > moment() ? moment($('.calendar-table').data('date')).add(1, 'seconds').toDate() : moment().add(1, 'seconds').toDate(),
    minDate: moment()
  });
  clear_table = function(e) {
    var b;
    b = $('.table-list tbody').find('tr').length;
    if (b < 1) {
      $('.table-list').remove();
      return $('.tip.description_count').html('Список предстоящих событий пуст');
    }
  };
  $('.remove-event').click(function(e) {
    var p, url;
    p = $(e.currentTarget).data('eventid');
    url = "events/" + p;
    return $.ajax({
      url: url,
      type: 'DELETE',
      dataType: 'json',
      success: function(data) {
        $(e.currentTarget).parents('tr').remove();
        return clear_table();
      }
    });
  });
  $('#editEvent .btn-default').click(function(e) {
    var formData, p, url;
    p = $('#editEvent #event_id').val();
    formData = new FormData();
    formData.append('event[name]', $('#editEvent #event_name').val());
    formData.append('event[description]', $('#editEvent #event_description').val());
    formData.append('event[will_begin_at]', $('#editEvent #event_will_begin_at').val());
    formData.append('event[staff_relation_attributes][vacancy_id]', $('#editEvent #event_staff_relation_attributes_vacancy_id').val());
    formData.append('event[staff_relation_attributes[candidate_id]]', $('#editEvent #event_candidate').val());
    url = "events/" + p;
    console.log('here');
    return $.ajax({
      url: url,
      type: 'PUT',
      dataType: 'json',
      processData: false,
      contentType: false,
      data: formData,
      success: function(data) {
        var event_time, formated_date, hours, minutes, month;
        event_time = new Date(data.e.will_begin_at);
        month = (event_time.getMonth() + 1 < 10 && '0' || '') + (event_time.getMonth() + 1);
        hours = (event_time.getUTCHours() < 10 && '0' || '') + event_time.getUTCHours();
        minutes = (event_time.getMinutes() < 10 && '0' || '') + event_time.getMinutes();
        formated_date = ((event_time.getDate() < 10 && '0' || '') + event_time.getDate()) + '/' + month + '/' + event_time.getFullYear();
        $("tr.event" + data.e.id + ">td.event_name").html(data.e.name);
        $("tr.event" + data.e.id + ">td.event_will_begin_at").html('<span class="label label-primary">' + (hours + ":" + minutes) + '</span>' + formated_date);
        $("tr.event" + data.e.id + ">td.event_description").html(data.e.description);
        $("tr.event" + data.e.id + ">td.event_vacancy").html(data.v === null ? data.v.name : void 0);
        $("tr.event" + data.e.id + ">td.event_candidate").html(data.c !== null ? data.c.name : void 0);
        return $('#editEvent').modal('hide');
      }
    });
  });
  format_date = function(current_time) {
    var data_day, date, day, formated_date, hours, minutes, month;
    date = new Date(current_time);
    hours = (date.getHours() < 10 && '0' || '') + date.getHours();
    minutes = (date.getMinutes() < 10 && '0' || '') + date.getMinutes();
    month = (date.getMonth() + 1 < 10 && '0' || '') + (date.getMonth() + 1);
    day = (date.getDate() < 10 && '0' || '') + date.getDate();
    formated_date = date.getFullYear() + '/' + month + '/' + day;
    return data_day = formated_date + " " + hours + ":" + minutes;
  };
  $('.edit-event').click(function(e) {
    var p;
    clear_table();
    p = $(e.currentTarget).data('eventid');
    return $.ajax({
      url: "/events/" + p,
      type: 'get',
      success: function(data) {
        var candidat, data_day;
        $('#editEvent #event_name').val(data.e.name);
        $('#editEvent #event_description').val(data.e.description);
        data_day = format_date(data.e.will_begin_at);
        $('#editEvent #event_will_begin_at').val(data_day);
        $('#editEvent #event_id').val(data.e.id);
        $('#editEvent .candidates_list tbody').empty();
        if (data.c !== null) {
          $('.cand-list').show();
        }
        if (data.v !== null) {
          $('#editEvent #event_staff_relation_attributes_vacancy_id').val(data.v.id);
        }
        if (data.c !== null) {
          candidat = JST['events/templates/candidates_list']({
            name: data.c.name,
            phone: data.c.phone,
            email: data.c.email,
            id: data.c.id
          });
          $('.candidates_list tbody').append(candidat);
        }
        return $('#editEvent').modal('show');
      }
    });
  });
  open_modal_at_day = function(data) {
    $('.candidates_list tbody').empty();
    $('.cand-list').hide();
    $('#dialog #event_will_begin_at').val(data);
    $('#dialog').addClass('show_modal');
    $('#event-dialog').data('day', data);
    return $('#dialog').modal('show');
  };
  $('.add_event').click(function() {
    var data_day;
    $('#event-dialog').modal('hide');
    data_day = format_date($('#event-dialog').data('day'));
    return open_modal_at_day(data_day);
  });
  $('td.day').click(function() {
    var current, current_time, data_day, select, select_day;
    if (!$(this).hasClass('has-events') && !$(this).hasClass('past')) {
      select_day = $(this).children('span').data('selectedDay');
      current_time = $(this).children('span').data('currentTime');
      select = new Date(select_day);
      current = new Date(current_time);
      if (current.getDay() >= select.getDay() && current.getMonth() >= select.getMonth() && current.getFullYear() >= select.getFullYear()) {
        data_day = format_date(current_time);
        return open_modal_at_day(data_day);
      } else {
        data_day = format_date(select_day);
        return open_modal_at_day(data_day);
      }
    }
  });
  add_candidate_to_table = function(vacancy_id) {
    return $.get("/v_candidates/" + vacancy_id, function(data) {
      var candidat, candidate, i, len, ref, tr_count;
      $('.candidates_list tbody').empty();
      $('.cand-list').show();
      ref = data.candidates;
      for (i = 0, len = ref.length; i < len; i++) {
        candidate = ref[i];
        candidat = JST['events/templates/candidates_list']({
          name: candidate.name,
          phone: candidate.phone,
          email: candidate.email,
          id: candidate.id
        });
        $('.candidates_list tbody').append(candidat);
      }
      return tr_count = $('.candidates_list tbody tr').length;
    });
  };
  return $('.form-group #event_staff_relation_attributes_vacancy_id').change(function() {
    var vacancy_id;
    vacancy_id = $(this).val();
    if (vacancy_id) {
      return add_candidate_to_table(vacancy_id);
    } else {
      $('.candidates_list tbody').empty();
      return $('.cand-list').hide();
    }
  });
});
