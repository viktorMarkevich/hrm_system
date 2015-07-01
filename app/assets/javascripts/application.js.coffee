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
# require_tree .

$(document).ready ->
  # if we on the new vacancy form
  if $('#new_vacancy')
    $inputSalary = $('input[name="vacancy[salary]"]')

    # by click on a radio button
    $('input[name="vacancy[salary_format]"]').click ->
      # if we check "По договоренности"
      if $(this).val() is 'По договоренности'
        # clear salary value
        $inputSalary.val 0
        # hide label "Зарплата" and salary input field
        $inputSalary.hide()
      else
        # show label "Зарплата" and salary input field
        $inputSalary.show()