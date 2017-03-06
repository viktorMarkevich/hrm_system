#= require candidates/vacancies_table
#= require candidates/vacancies_table_row

$(document).ready ->
  $('.vacancies_list').append(JST["candidates/vacancies_table"]({}))
  $('tbody').append(JST["candidates/vacancies_table_row"]({name: "Developer", salary: "1500 USD", status: "Open", close: "<i class = 'glyphicon glyphicon-remove-circle'></i>" }))
