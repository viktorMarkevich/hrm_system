$(document).ready ->
  $.ajax '/cv_sources',
    type: 'GET'
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      $("#candidate_source").autocomplete({ source: data.sources })