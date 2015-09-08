# coding 'utf-8'
$(document).ready ->

  $('body').on 'change', '.vacancy_sr_status', ->
      id = $(this).attr('id')
      console.log(id)
      $('#form-'+id).trigger('submit').trigger('submit');
      return