# coding 'utf-8'
$(document).ready ->
  $('body').on 'change', '#upload_resume_file', ->
    $(this).closest("form").submit()

  $('.resume_upload').on 'click', ->
    $('#upload_resume_file').click()

  $ ->
    geo_names = []
    $.ajax(
      url: '/geo_names'
      type: 'GET'
      dataType: 'json').done((json) ->
        geo_names = json
        console.log geo_names
        $('#candidate_city_of_residence').autocomplete source: geo_names
    )
    return