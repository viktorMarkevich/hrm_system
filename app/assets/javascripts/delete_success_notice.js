// deleting succes alert after user registration
$(document).on('ready turbolinks:load', function() {
	$('.alert.alert-info.fade.in').fadeOut(2000);
});

//deleting success alert after candidat creation
$(document).on('ready turbolinks:load', function() {
	$('.alert.alert-success.fade.in').fadeOut(2000);
});