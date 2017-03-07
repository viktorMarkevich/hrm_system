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
    return false

  $('body').on 'click', '.resume-save-btn', (e) ->
    btn = $(this)
    e.preventDefault()
    $.ajax(
      url: $(this).attr('href')
#      data: original_cv_data: $('.resume').text()
      data: original_cv_data: $('div.froala-editor').froalaEditor 'html.get'
      type: 'POST'
      dataType: 'json').done( ->
      if $('.froala-editor').data('froala.editor')
        $('.froala-editor').froalaEditor 'destroy'
        $('.resume-save-btn').addClass('resume-edit-btn').removeClass('resume-save-btn');
        btn.text 'Редактировать'
    )
    return false