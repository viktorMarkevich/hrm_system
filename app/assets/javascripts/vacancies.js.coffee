# coding 'utf-8'

$(document).ready ->

  $('.vacancy_sr_status').change ->
    id = $(this).attr('id')
    $('#form-'+id).trigger 'submit.rails'
    return

#  # if we on the new vacancy form
#  if $('#new_vacancy')
#    $inputSalary = $('input[name="vacancy[salary]"]')
#
#    # by click on a radio button
#    $('input[name="vacancy[salary_format]"]').click ->
#      # if we check "По договоренности"
#      if $(this).val() is "По договоренности"
#        # hide label "Зарплата" and salary input field
#        $inputSalary.hide()
#      else
#        # show label "Зарплата" and salary input field
#        $inputSalary.show()
#
#  # if we on the vacancy show page
#  $getIntoStatusButton = $(".candidates-for-vacancy")
#  if($getIntoStatusButton)
#    disableDefaultOption()
#
#    addedToVacancyCandidatesIds = []
#    $('#add-to-vacancy').click ->
#      $('#myModal').modal()
#
#    $('#btn-apply').click ->
#      $checked_boxes = $('input[name=\"mark-as-found-candidate\"]:checked')
#      for chbox in $checked_boxes
#        addedToVacancyCandidatesIds.push $(chbox).val()
#        $(chbox).closest('tr').remove()
#      vacancy_id = $('#candidates-multiselect').attr('data-vacancyid')
#      $.ajax
#        url: "/vacancies/#{vacancy_id}/mark_candidates_as_found"
#        type: 'POST'
#        data:
#          candidates_ids: addedToVacancyCandidatesIds
#        success: (response) ->
#          buildCandidatesTable(response)
#          setCandidatesTableCaptionByStatus('Найденные')
#          $('#myModal').modal('hide')
#
#    $('#vacancy-candidates').on 'change', '.status-picker', ->
#      $row_to_remove = $(this).parents('tr')
#      vacancy_id = $(this).attr('data-vacancyid')
#      $.ajax
#        url: "/vacancies/#{vacancy_id}/change_candidate_status"
#        type: 'POST'
#        data:
#          candidate_id: $(this).attr('data-candidateid')
#          status: $(this).val()
#        success: (response) ->
#          $row_to_remove.remove() if response.status is "ok"
#          if response.candidate
#            addPassiveCandidateToList(response.candidate)