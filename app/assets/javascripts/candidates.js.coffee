# coding 'utf-8'
#=require froala_editor.min.js
$(document).ready ->
  $.validate (
    form: '.candidate-form'
    lang: 'ru'
  )

  $('body').on 'click', '.resume-edit-btn', (e) ->
    e.preventDefault()
    $('.froala-editor').froalaEditor(
      editorClass: '.resume'
    )
    $('.resume-edit-btn').addClass('resume-save-btn').removeClass( 'resume-edit-btn');
    $(this).text 'Сохранить'
    return

  $('body').on 'click', '.resume-save-btn', (e) ->
    e.preventDefault()
    if $('.froala-editor').data('froala.editor')
      $('.froala-editor').froalaEditor 'destroy'
      $('.resume-save-btn').addClass('resume-edit-btn').removeClass( 'resume-save-btn');
      $(this).text 'Редактировать'

    $.ajax
      url: $(this).attr('href')
      data: original_cv_data: $('.resume').text()
      type: 'POST'
      dataType: 'json'

    return false