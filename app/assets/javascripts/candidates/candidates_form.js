// coding 'utf-8'
//=require jquery_ujs
//=require jquery.ui.datepicker
//=require jquery.ui.datepicker-ru
//=require candidates/datepicker
//=require form-validator/jquery.form-validator
//=require jquery.ui.autocomplete
//=require candidates/autocomplete
//=require candidates/candidates_geo_names.js

$(document).ready(function() {
    return $.validate({
        form: '.candidate-form',
        lang: 'ru'
    });
});