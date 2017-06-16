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

#  return $('#candidate_tag_list').autocomplete({
#  source: $('#candidate_tag_list').data('autocomplete-source')
#  });

  availableTags = $('#candidate_tag_list').data('autocomplete-source')

  split = (val) ->
    val.split /,\s*/

  extractLast = (term) ->
    split(term).pop()

  $('#candidate_tag_list').on('keydown', (event) ->
    if event.keyCode == $.ui.keyCode.TAB and $(this).autocomplete('instance').menu.active
      event.preventDefault()
    return
  ).autocomplete
    minLength: 0
    source: (request, response) ->
      response $.ui.autocomplete.filter(availableTags, extractLast(request.term))
      return
    focus: ->

      false
    select: (event, ui) ->
      terms = split(@value)

      terms.pop()

      terms.push ui.item.value

      terms.push ''
      @value = terms.join(', ')
      false
  return