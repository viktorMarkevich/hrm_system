// coding 'utf-8'
//=require jquery.ui.datepicker
//=require jquery.ui.datepicker-ru
//=require candidates/datepicker
//=require form-validator/jquery.form-validator
//=require jquery.ui.autocomplete
//=require candidates/autocomplete
//=require candidates/candidates_geo_names.js
//=require selectize

$(document).ready(function() {
    return $.validate({
        form: '.candidate-form',
        lang: 'ru'
    });
});

//selectize for choose company and modal for add new in candidate form

$(document).ready(function() {
    var selectizeCallback = null;
    var company_modal = $('.company-modal');
    var new_company = $('#new_company');
    // var errorBlock = $('.error_block');

    company_modal.on('hide.bs.modal', function(e) {
        if (selectizeCallback != null) {
            selectizeCallback();
            selectizeCallback = null;
        }

        new_company.trigger('reset');
        // errorBlock.hide();
        $.rails.enableFormElements(new_company);
    });

    new_company.on('submit', function(e) {
        e.preventDefault();
        $.ajax({
            method: 'POST',
            url: $(this).attr('action'),
            data: $(this).serialize(),
            success: function(response) {
                selectizeCallback({value: response.id, text: response.name});
                selectizeCallback = null;

                company_modal.modal('toggle');
                console.log(response);
            },
            error: function(response) {
                // var item;
                // $.each(JSON.parse(response['responseText']), function(key, value){
                //     if (key == 'errors') {
                //         item = errorBlock.find('li.item');
                //         item.text(value);
                //         errorBlock.find('ul').append(item);
                //         item.show();
                //     }
                // });
                // $.rails.enableFormElements(new_company);
                // errorBlock.show();
                console.log(response.responseJSON);
            }
        });
    });

    $('.selectize').selectize({
        create: function(input, callback) {
            selectizeCallback = callback;

            company_modal.modal();
            $('#company_name').val(input);
        }
    });
});