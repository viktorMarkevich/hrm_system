# coding 'utf-8'
$('body').on 'change', '.vacancy_sr_status', ->
  id = $(this).attr('id')
  $('#form-'+id).trigger 'submit.rails'
  return