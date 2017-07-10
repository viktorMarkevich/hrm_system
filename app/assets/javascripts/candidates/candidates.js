// coding 'utf-8'
//=require jquery.ui.dialog
//=require jquery.ui.autocomplete

$(document).ready(function() {

    var body = $('body');
    var dropdown_active = $('.dropdown .active');
    var exportCandidates = $('#exportCandidates');

    body.on('click', '.export', function(e) {
        e.preventDefault();
        var current_href = $(this).attr('href') + '?page=' + $('.pagination li.active a').text();
        var all_href = $(this).attr('href');
        if (dropdown_active.text() !== 'Все') {
            current_href += '&status=' + dropdown_active.text();
            all_href += '?status=' + dropdown_active.text();
        }
        $('.export-current').attr('href', current_href);
        $('.export-all').attr('href', all_href);
        exportCandidates.modal('show');
        return false;
    });
    return body.on('click', '.export-modal', function(e) {
        return exportCandidates.modal('hide');
    });
});