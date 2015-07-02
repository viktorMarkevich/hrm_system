$(document).ready ->
  # if we on the new vacancy form
  if $('#new_vacancy')
    $inputSalary = $('input[name="vacancy[salary]"]')

    # by click on a radio button
    $('input[name="vacancy[salary_format]"]').click ->
      # if we check "По договоренности"
      if $(this).val() is 'По договоренности'
        # clear salary value
        $inputSalary.val 1
        # hide label "Зарплата" and salary input field
        $inputSalary.hide()
      else
        # show label "Зарплата" and salary input field
        $inputSalary.show()