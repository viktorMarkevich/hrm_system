# coding 'utf-8'
disableDefaultOption = ->
  $('select.status-picker option:first-child').attr("disabled", "disabled");

addPassiveCandidateToList = (candidate) ->
  $('#candidates-multiselect tbody').append(
    "<tr>" +
      "<td>" +
        "<input type=\"checkbox\"  name=\"mark-as-found-candidate\" id=\"mark-as-found-candidate\" value=\"" + candidate.id + "\">" +
        " " + candidate.name +
      "</td>" +
      "<td>" + candidate.salary + "</td>" +
      "<td>Имеет статус <span class='label label-primary'>" + 'Нейтрален' + "</span></td>" +
    "</tr>"
  )

buildCandidatesTable = (data) ->
  $candidatesTable = $('#vacancy-candidates tbody')
  $candidatesTable.html('')
  options = []
  options.push "<option value='Перевести в статус'>Перевести в статус</option>"
  for status in data.statuses
    options.push "<option value='" + status + "'>" + status + "</option>"

  for candidate in data.candidates
    $candidatesTable.append(
      "<tr>" +
      "<td><a href='/candidates/'+id>" + candidate.name + "</a></td>"+
      "<td>" + candidate.salary + "</td>"+
      "<td><span class='label label-primary'>" + candidate.created_at + "</span></td>"+
      "<td><select name=\"status-picker\" class=\"status-picker\"></td>" +
      "</tr>")
    $select = $('select').last()

    $select.attr('data-candidateid', candidate.id);
    $select.attr('data-vacancyid', data.vacancy_id);
    $select.append(options)
    disableDefaultOption()
    $select.val(data.current_status)

$(document).ready ->
  # if we on the new vacancy form
  if $('#new_vacancy')
    $inputSalary = $('input[name="vacancy[salary]"]')

    # by click on a radio button
    $('input[name="vacancy[salary_format]"]').click ->
      # if we check "По договоренности"
      if $(this).val() is "По договоренности"
        # hide label "Зарплата" and salary input field
        $inputSalary.hide()
      else
        # show label "Зарплата" and salary input field
        $inputSalary.show()

  # if we on the vacancy show page
  $getIntoStatusButton = $(".candidates-for-vacancy")
  if($getIntoStatusButton)
    disableDefaultOption()

    addedToVacancyCandidatesIds = []
    $('#add-to-vacancy').click ->
      $('#myModal').modal()

    $('#btn-apply').click ->
      $checked_boxes = $('input[name=\"mark-as-found-candidate\"]:checked')
      for chbox in $checked_boxes
        addedToVacancyCandidatesIds.push $(chbox).val()
        $(chbox).closest('tr').remove()
      vacancy_id = $('#candidates-multiselect').attr('data-vacancyid')
      $.ajax
        url: "/vacancies/#{vacancy_id}/mark_candidates_as_found"
        type: 'POST'
        data:
          candidates_ids: addedToVacancyCandidatesIds
        success: (response) ->
          buildCandidatesTable(response)
          setCandidatesTableCaptionByStatus('Найденные')
          $('#myModal').modal('hide')

    $getIntoStatusButton.click ->
      vacancy_id = $(this).data('vacancy-id')
      $.ajax
        url: "/vacancies/#{vacancy_id}/search_candidates_by_status"
        type: "GET"
        data:
          status: $(this).data('status-name')
        success: (response) ->
          buildCandidatesTable(response)
          setCandidatesTableCaptionByStatus(response.current_status)
          return

    $('#vacancy-candidates').on 'change', '.status-picker', ->
      $row_to_remove = $(this).parents('tr')
      vacancy_id = $(this).attr('data-vacancyid')
      $.ajax
        url: "/vacancies/#{vacancy_id}/change_candidate_status"
        type: 'POST'
        data:
          candidate_id: $(this).attr('data-candidateid')
          status: $(this).val()
        success: (response) ->
          $row_to_remove.remove() if response.status is "ok"
          if response.candidate
            addPassiveCandidateToList(response.candidate)