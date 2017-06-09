#= require candidates/vacancies_table
#= require candidates/vacancies_table_row
#= require candidates/vacancies_list_row

$(document).ready ->
  $('body').on('click', '.vacancies_list ul.dropdown-menu li a', (event) ->
    event.preventDefault()
    vacancy_list = $('.vacancies_list')

    $.ajax this.href,
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        if vacancy_list.children('table.table.table-bordered.table-hover').length == 0
          vacancy_list.append(JST["candidates/vacancies_table"]({}))
        $('.vacancies_list table tbody').append(JST['candidates/vacancies_table_row']({
                          name: data.name,
                          salary: "#{data.salary} #{data.salary_format}",
                          css_class: "label #{getCssClass(data.status)}",
                          status: data.status,
                          close: '/staff_relations/' + data.id
        }))
        $(event.target).parent().remove()

    getCssClass = (status) ->
      switch status
        when 'Найденные' then 'label-default'
        when 'Отобранные' then 'label-primary'
        when 'Собеседование' then 'label-info'
        when 'Утвержден' then 'label-success'
        when 'Не подходит' then 'label-warning'
        when 'Отказался' then 'label-danger'
        else []
    return
  )

  $('body').on('click', '.vacancies_list table a', (event) ->
    event.preventDefault()
    vacancy_list = $('.vacancies_list')
    $.ajax this.href,
      type: 'DELETE'
      dataType: 'json'
      success: (data) ->
        if vacancy_list.children('table.table.table-bordered.table-hover').length == 0
          vacancy_list.append(JST['candidates/vacancies_table']({}))
        $('.vacancies_list ul.dropdown-menu').append(JST['candidates/vacancies_list_row']({
          name: data.vacancy_name,
          set_vacancy: "/candidates/#{data.candidate_id}/set_vacancies?vacancy_id=#{data.vacancy_id}"
        }))
        $(event.target).closest('tr').remove()
    return false
  )