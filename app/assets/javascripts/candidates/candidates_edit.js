// coding 'utf-8'
//=require froala_editor.min.js
//=require jquery.ui.autocomplete

$(document).ready(function() {

    var body = $('body');
    var froala_editor = $('.froala-editor');

    body.on('click', '.resume-edit-btn', function(e) {
        e.preventDefault();
        froala_editor.froalaEditor({
            editorClass: '.resume'
        });
        $('.resume-edit-btn').addClass('resume-save-btn').removeClass('resume-edit-btn');
        $(this).text('Сохранить');
        return false;
    });
    return body.on('click', '.resume-save-btn', function(e) {
        var btn;
        btn = $(this);
        e.preventDefault();
        $.ajax({
            url: $(this).attr('href'),
            data: {
                original_cv_data: $('div', froala_editor).froalaEditor('html.get')
            },
            type: 'PUT',
            dataType: 'json'
        }).done(function() {
            if (froala_editor.data('froala.editor')) {
                froala_editor.froalaEditor('destroy');
                $('.resume-save-btn').addClass('resume-edit-btn').removeClass('resume-save-btn');
                return btn.text('Редактировать');
            }
        });
        return false;
    });
});