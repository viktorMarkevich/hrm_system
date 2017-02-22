# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require candidates
# require_tree .

$(document).ready ->
  if window.location.pathname.indexOf('events') > 0
    $('ul.nav.navbar-nav:first').find('a[href*="'+window.location.pathname.split('/')[1]+'"]:not([id])').addClass 'active current'
  else if window.location.pathname.indexOf('stickers') > 0
    $('ul.nav.navbar-nav:first').find('a[href*="'+window.location.pathname.split('/')[1]+'"]').addClass 'active current'
  else if window.location.pathname.indexOf('new') > 0
    $('ul.nav.navbar-nav:first').find('a[href*="'+window.location.pathname.split('/')[1]+'/new"]').addClass 'active current'
  else if window.location.pathname.indexOf('archives') < 0
    $('ul.nav.navbar-nav:first').find('a[href*="'+window.location.pathname.split('/')[1]+'"]:not([id])').addClass 'active current'
  else
    $('ul.nav.navbar-nav:first').find('a[href*="'+window.location.pathname.split('/')[2]+'"]:not([id])').addClass 'active current'

$(document).ajaxError (event, xhr, options, exc) ->
  errors = JSON.parse(xhr.responseText)
  er = '<ul>'
  i = 0
  while i < errors.length
    list = errors[i]
    er += '<li>' + list + '</li>'
    i++
  er += '</ul>'
  $('#error_explanation').html er
  return








