# coding 'utf-8'
#= require vacancies/vacancies_candidate_table
#= require vacancies/vacancies_candidate_row
#= require vacancies/vacancies_no_candidates
renderVacancyCandidates = (data) ->
  $('.vacancy-candidates .content').empty()
  if data.vacancy_candidates.length != 0
    $('.vacancy-candidates .content').append(JST["vacancies/vacancies_candidate_table"])
    $.each data.vacancy_candidates, (i, candidate ) ->
      $('.vacancy-candidates .content tbody').append(JST["vacancies/vacancies_candidate_row"]({
        candidate_id: candidate.id,
        candidate_name: candidate.name,
        candidate_salary: candidate.salary,
        candidate_updated_at: candidate.updated_at,
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
