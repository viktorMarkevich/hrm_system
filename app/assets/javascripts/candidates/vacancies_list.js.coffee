#= require candidates/vacancies_table
#= require candidates/vacancies_table_row

$(document).ready ->
  $('.vacancies_list ul.dropdown-menu li a').click (event) ->
    event.preventDefault()
    vacancy_list = $('.vacancies_list')
    $.ajax this.href,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        console.log(data)
        if vacancy_list.children('table.table.table-bordered.table-hover').length == 0
          vacancy_list.append(JST["candidates/vacancies_table"]({}))
        $('.vacancies_list table tbody').append(JST["candidates/vacancies_table_row"]({
                          name: data.name,
                          salary: "#{data.salary} #{data.salary_format}",
                          status: data.status,
                          close: "<i class = 'glyphicon glyphicon-remove-circle'></i>"
        }))
