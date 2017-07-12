//=require jquery.ui.autocomplete

$(document).ready(function() {
    return $.ajax('/cv_sources', {
        type: 'GET',
        dataType: 'json',
        success: function(data, textStatus, jqXHR) {
            return $("#candidate_source").autocomplete({
                source: data.sources
            });
        }
    });
});