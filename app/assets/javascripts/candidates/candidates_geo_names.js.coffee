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