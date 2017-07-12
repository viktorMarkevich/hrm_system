$(function() {
    $('#candidate_birthday').datepicker({
        dateFormat: 'dd-mm-yy',
        yearRange: "1960:+0",
        changeMonth: true,
        changeYear: true
    });
    return $.datepicker.setDefaults($.datepicker.regional['ru']);
});