// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets//sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require delete_success_notice.js
// require_tree .

$(document).ready(function() {
    var nav_first = $('ul.nav.navbar-nav:first');
    if (window.location.pathname.indexOf('events') > 0) {
        return nav_first.find('a[href*="' + window.location.pathname.split('/')[1] + '"]:not([id])').addClass('active current');
    } else if (window.location.pathname.indexOf('stickers') > 0) {
        return nav_first.find('a[href*="' + window.location.pathname.split('/')[1] + '"]').addClass('active current');
    } else if (window.location.pathname.indexOf('new') > 0) {
        return nav_first.find('a[href*="' + window.location.pathname.split('/')[1] + '/new"]').addClass('active current');
    } else if (window.location.pathname.indexOf('archives') < 0) {
        return nav_first.find('a[href*="' + window.location.pathname.split('/')[1] + '"]:not([id])').addClass('active current');
    } else {
        return nav_first.find('a[href*="' + window.location.pathname.split('/')[2] + '"]:not([id])').addClass('active current');
    }
});

$(document).ajaxError(function(event, xhr, options, exc) {
    var er, errors, i, list;
    errors = JSON.parse(xhr.responseText);
    er = '<ul>';
    i = 0;
    while (i < errors.length) {
        list = errors[i];
        er += '<li>' + list + '</li>';
        i++;
    }
    er += '</ul>';
    $('#error_explanation').html(er);
});

$(document).ready(function() {
    var extractLast, split;
    $('body').on('change', '#upload_resume_file', function() {
        return $(this).closest("form").submit();
    });
    $('.resume_upload').on('click', function() {
        return $('#upload_resume_file').click();
    });
    split = function(val) {
        return val.split(/,\s*/);
    };
    extractLast = function(term) {
        return split(term).pop();
    };
    $('#tags').autocomplete({
        minLength: 0,
        delay: 0,
        source: function(request, response) {
            $.ajax({
                url: '/searches',
                data: {
                    term: extractLast(request.term)
                },
                dataType: 'json',
                type: 'GET',
                success: function(data) {
                    return response(data);
                }
            });
        },
        focus: function() {
            return false;
        },
        select: function(event, ui) {
            var terms;
            terms = split(this.value);
            terms.pop();
            terms.push(ui.item.value);
            jQuery.uniqueSort(terms);
            console.log(ui.item.value);
            terms.push('');
            this.value = terms.join(', ');
            return false;
        }
    });
});