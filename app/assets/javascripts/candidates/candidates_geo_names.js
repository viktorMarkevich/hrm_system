$(function() {
    var geo_names = [];
    $.ajax({
        url: '/geo_names',
        type: 'GET',
        dataType: 'json'
    }).done(function(json) {
        geo_names = json;
        return $('#candidate_city_of_residence').autocomplete({
            source: geo_names
        });
    });
});