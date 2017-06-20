# coding 'utf-8'
#=require jquery.ui.dialog

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

$(document).ready ->

  split = (val) ->
    val.split /,\s*/
  extractLast = (term) ->
    split(term).pop()

  $('#candidate_tag_list').autocomplete
    minLength: 0
    delay: 0
    source: (request, response) ->
      $.ajax
        url: '/searches'
        data: term: extractLast(request.term)
        dataType: 'json'
        type: 'GET'
        success: (data) ->
          response data
      return
    focus: ->
      false
    select: (event, ui) ->
      terms = split(@value)
      terms.pop()
      terms.push ui.item.value
      jQuery.uniqueSort(terms)
      console.log(ui.item.value)
      terms.push ''
      @value = terms.join(', ')
      false
  return