# coding 'utf-8'
#=require jquery.ui.dialog
  $("body").on('click','.export', (e) ->
    e.preventDefault()
    $('.export-current').attr('href', $(this).attr('href'))
    $('.export-all').attr('href', $(this).attr('href'))
    $('#exportCandidates').modal 'show'
    return false
  )

  $("body").on('click','.export-cancel', (e)->
    $('#exportCandidates').modal 'hide'
  )
