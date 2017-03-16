# coding 'utf-8'
#= require vacancies/vacancies_candidate_row
#= require vacancies/vacancies_no_candidates

$(document).ready ->
  $('body').on 'change', '.vacancy_sr_status', ->
    id = $(this).attr('id')
    $('#form-'+id).trigger 'submit.rails'

  $('body').on 'click', '.vacancy-candidates a.btn', (event) ->
    event.preventDefault()
    $.ajax this.href,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        console.log data.vacancy_candidates.length
        $('.vacancy-candidates .content').empty()
        if data.vacancy_candidates.length != 0
          $.each data.vacancy_candidates, (i, candidate ) ->
            $('.vacancy-candidates .content').append(JST["vacancies/vacancies_candidate_row"]({
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
    return false
