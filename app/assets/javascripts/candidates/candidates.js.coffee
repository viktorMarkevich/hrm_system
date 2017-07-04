# coding 'utf-8'
#=require jquery.ui.dialog
#=require jquery.ui.autocomplete
#=require select2

$(document).ready ->

  $('body').on('click','.export', (e) ->
    e.preventDefault()
    current_href = $(this).attr('href') + '?page=' + $('.pagination li.active a').text()
    all_href = $(this).attr('href')
    if $('.dropdown .active').text() != 'Все'
      current_href += '&status=' + $('.dropdown .active').text()
      all_href += '?status=' + $('.dropdown .active').text()
    $('.export-current').attr('href',current_href)
    $('.export-all').attr('href', all_href)
    $('#exportCandidates').modal 'show'
    return false
  )

  $('body').on('click','.export-modal', (e)->
    $('#exportCandidates').modal 'hide'
  )

  #multiple select candidate.companies

  $("#candidate_company_ids").select2(

  );