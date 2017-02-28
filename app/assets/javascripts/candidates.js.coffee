# coding 'utf-8'
#=require jquery.ui.datepicker
#=require datepicker
#=require form-validator/jquery.form-validator
#=require jquery.ui.autocomplete
#=require autocomplete


$(document).ready ->
  $('body').on 'change', '#upload_resume_file', ->
    $(this).closest("form").submit()

  $('.resume_upload').on 'click', ->
    $('#upload_resume_file').click()

  $.validate (
    form: '.candidate-form'
    lang: 'ru'
  )