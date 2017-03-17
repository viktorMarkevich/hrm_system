# coding 'utf-8'
#= require vacancies/vacancies_candidate_table
#= require vacancies/vacancies_candidate_row
#= require vacancies/vacancies_no_candidates
#= require vacancies/candidates_modal_form
#= require vacancies/candidates_modal_row
#= require vacancies/candidates_modal_staff_relation_row
#= require vacancies/candidates_modal_candidate_status_row

renderVacancyCandidates = (data) ->
  $('.vacancy-candidates .content').empty()
  if data.vacancy_candidates.length != 0
    $('.vacancy-candidates .content').append(JST["vacancies/vacancies_candidate_table"])
    $.each data.vacancy_candidates, (i, candidate ) ->
      updated_at = new Date(candidate.updated_at)
      $('.vacancy-candidates .content tbody').append(JST["vacancies/vacancies_candidate_row"]({
        candidate_id: candidate.id,
        candidate_name: candidate.name,
        candidate_salary: candidate.salary,
        candidate_updated_at: updated_at.toLocaleFormat('%F %H:%M'),
        vacancy_id: data.vacancy.id,
        vacancy_user_id: data.vacancy.user_id
      }))
      return
  else
    $('.vacancy-candidates .content').append(JST["vacancies/vacancies_no_candidates"])

$(document).ready ->
  $('body').on 'change', '.vacancy_sr_status', ->
#    id = $(this).attr('id')
#    $('#form-'+id).trigger 'submit.rails'
    params = {
      vacancy: {
        candidate_id: $(this).closest('form').find('#vacancy_candidate_id').val(),
        user_id: $(this).closest('form').find('#vacancy_user_id').val(),
        sr_status: $(this).val()
      }
    }
    $.ajax $(this).closest('form').attr('action'),
      data: params
      type: 'PUT'
      dataType: 'json'
      success: (data) ->
        renderVacancyCandidates(data)

  $('body').on 'click', '.vacancy-candidates a.btn', (event) ->
    event.preventDefault()
    $.ajax this.href,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        renderVacancyCandidates(data)
    return false

  $('body').on 'click', '.staff-relation', (event) ->
    event.preventDefault()
    $.ajax this.href,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        $('.modal-body').empty()
        $('.modal-body').append(JST["vacancies/candidates_modal_form"]({
          vacancy_id: data.id,
        }))
        $.each data.candidates, (i, candidate ) ->
          $('.modal-body tbody').append(JST["vacancies/candidates_modal_row"]({
            candidate_id: candidate.id,
            candidate_name: candidate.name,
            candidate_salary: candidate.salary
          }))
          if candidate.staff_relations.length != 0
            $.each candidate.staff_relations, (i, staff_relation ) ->
              $(".modal-body .candidate_#{candidate.id} .staff_relations").append(JST["vacancies/candidates_modal_staff_relation_row"]({
                staff_realation_status: staff_relation.status,
                staff_realation_vacancy_name: staff_relation.vacancy_name
              }))
              return
            return
          else
            $(".modal-body .candidate_#{candidate.id} .staff_relations").append(JST["vacancies/candidates_modal_candidate_status_row"]({
              staff_realation_status: candidate.status
            }))

        $('#dialog').modal('show')
    return false
