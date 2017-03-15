# coding 'utf-8'
#=require jquery.ui.dialog

$("body").on('click','.export', (e) ->
  e.preventDefault()
  href = $(this).attr('href') + '?page=' + $('.pagination li.active a').text()
  if $('.dropdown .active').text() != 'Все'
    href += '&status=' + $('.dropdown .active').text()
  $('.export-current').attr('href',href)
  $('.export-all').attr('href', $(this).attr('href'))
  $('#exportCandidates').modal 'show'
  return false
)

$("body").on('click','.export-modal', (e)->
  $('#exportCandidates').modal 'hide'
)
