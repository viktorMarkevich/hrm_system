# coding 'utf-8'
$(document).ready ->

#  $('#add-to-vacancy').click ->
#    $('#dialog').modal('show')
#
#  $('#btn-apply').click ->
#    addedToVacancyCandidatesIds = []
#    $checked_boxes = $('input[name=\"mark-as-found-candidate\"]:checked')
#    for chbox in $checked_boxes
#      addedToVacancyCandidatesIds.push $(chbox).val()
#      $(chbox).closest('tr').remove()
#    $('#dialog').modal('hide')
#    $.ajax({
#      type: "POST",
#      url: "/staff_relations",
#      data: { vacancy_id: $('.candidates_list_in_modal').attr('data-vacancyid'), candidates_ids: addedToVacancyCandidatesIds },
#      success:(data) ->
#        $('.results').html data
#    })

$('body').on 'change', '.vacancy_sr_status', ->
    id = $(this).attr('id')
    $('#form-'+id).trigger 'submit.rails'
    return