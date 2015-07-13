highlightDefaultTab = ->
  $defaultTab = $(".candidates-for-vacancy").first()
  $defaultTab.siblings().removeClass("active")
  $defaultTab.addClass('active')

disableDefaultOption = ->
  $('select option:first-child').attr("disabled", "disabled");

setCandidatesTableCaptionByStatus = (status) ->
  $('#vacancy-candidates caption').text('Кандидаты со статусом "' + status + '"')

addPassiveCandidateToList = (candidate) ->
  $('#candidates-multiselect').append(
    "<div class = \"item\">" +
      "<label>" +
        "<input type=\"checkbox\"  name=\"applied-candidate\" id=\"applied-candidate\" value=\"" + candidate.id + "\">" +
        " " + candidate.name +
      "</label>" +
    "</div>"
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
      "<th>" + candidate.id + "</th>" +
      "<td>" + candidate.name + "</td>"+
      "<td>" + candidate.salary + "</td>"+
      "<td>" + candidate.created_at + "</td>"+
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
    highlightDefaultTab()
    disableDefaultOption()

    addedToVacancyCandidatesIds = []
    $('#add-to-vacancy').click ->
      $('#myModal').modal()

    $('#btn-apply').click ->
      $checked_boxes = $('input[name=\"applied-candidate\"]:checked')
      for chbox in $checked_boxes
        addedToVacancyCandidatesIds.push $(chbox).val()
        $(chbox).parent().remove()

      $.ajax
        url: '/vacancies/add_candidates_to_founded'
        type: 'POST'
        data:
          vacancy_id: $('#candidates-multiselect').attr('data-vacancyid')
          candidates_ids: addedToVacancyCandidatesIds
        success: (response) ->
          buildCandidatesTable(response)
          setCandidatesTableCaptionByStatus('Найденные')
          $('#myModal').modal('hide')
          highlightDefaultTab()

    $getIntoStatusButton.click ->
      # set active tab
      $(this).siblings().removeClass("active");
      $.ajax
        url: "/vacancies/search_candidates_by_status"
        type: "POST"
        data:
          status_index: $(this).data('status-index')
          vacancy_id: $(this).data('vacancy-id')
        success: (response) ->
          buildCandidatesTable(response)
          setCandidatesTableCaptionByStatus(response.current_status)
          return

    $('#vacancy-candidates').on 'change', '.status-picker', ->
      $row_to_remove = $(this).parents('tr')

      $.ajax
        url: '/vacancies/change_candidate_status'
        type: 'POST'
        data:
          vacancy_id: $(this).attr('data-vacancyid')
          candidate_id: $(this).attr('data-candidateid')
          status: $(this).val()
        success: (response) ->
          $row_to_remove.remove() if response.status is "ok"
          if response.available_candidate
            addPassiveCandidateToList(response.available_candidate)