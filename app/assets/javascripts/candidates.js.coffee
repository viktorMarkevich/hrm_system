# coding 'utf-8'
$(document).ready ->
  $('body').on 'change', '#upload_resume_file', ->
    $(this).closest("form").submit()

  $('.resume_upload').on 'click', ->
    $('#upload_resume_file').click()
