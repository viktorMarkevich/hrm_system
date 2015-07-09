disableDefaultOption = ->
  $('select option:first-child').attr("disabled", "disabled");

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
          $('#myModal').modal('hide')

    $getIntoStatusButton.click ->
      $.ajax
        url: "/vacancies/search_candidates_by_status"
        type: "POST"
        data:
          status_index: $(this).data('status-index')
          vacancy_id: $(this).data('vacancy-id')
        success: (response) ->
          # clean candidates list for vacancy
          $candidatesTable = $('#vacancy-candidates tbody')
          $candidatesTable.html('')
          options = []
          options.push "<option value='Перевести в статус'>Перевести в статус</option>"
          for status in response.statuses
            options.push "<option value='" + status + "'>" + status + "</option>"

          for candidate in response.candidates
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
            $select.attr('data-vacancyid', response.vacancy_id);
            $select.append(options)
            disableDefaultOption()
            $select.val(response.current_status)
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