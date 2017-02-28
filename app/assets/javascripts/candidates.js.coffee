# coding 'utf-8'
$(document).ready ->
  $('body').on 'change', '#upload_resume_file', ->
    $(this).closest("form").submit()

  $('.resume_upload').on 'click', ->
    $('#upload_resume_file').click()

  $ ->
  cities = [
    'ActionScript'
    'AppleScript'
    'Asp'
    'BASIC'
    'C'
    'C++'
    'Clojure'
    'COBOL'
    'ColdFusion'
    'Erlang'
    'Fortran'
    'Groovy'
    'Haskell'
    'Java'
    'JavaScript'
    'Lisp'
    'Perl'
    'PHP'
    'Python'
    'Ruby'
    'Scala'
    'Scheme'
  ]
  $('#candidate_city_of_residence').autocomplete source: cities
  return