//= require candidates/vacancies_table
//= require candidates/vacancies_table_row
//= require candidates/vacancies_list_row

$(document).ready(function() {

    var body = $('body');
    var vacancy_list = $('.vacancies_list');

    body.on('click', '.vacancies_list ul.dropdown-menu li a', function(event) {
        event.preventDefault();
        var getCssClass;

        $.ajax(this.href, {
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                if (vacancy_list.children('table.table.table-bordered.table-hover').length === 0) {
                    vacancy_list.append(JST["candidates/vacancies_table"]({}));
                }
                $('table tbody', vacancy_list).append(JST['candidates/vacancies_table_row']({
                    name: data.name,
                    salary: data.salary + " " + data.salary_format,
                    css_class: "label " + (getCssClass(data.status)),
                    status: data.status,
                    close: '/staff_relations/' + data.id
                }));
                return $(event.target).parent().remove();
            }
        });
        getCssClass = function(status) {
            switch (status) {
                case 'Найденные':
                    return 'label-default';
                case 'Отобранные':
                    return 'label-primary';
                case 'Собеседование':
                    return 'label-info';
                case 'Утвержден':
                    return 'label-success';
                case 'Не подходит':
                    return 'label-warning';
                case 'Отказался':
                    return 'label-danger';
                default:
                    return [];
            }
        };
    });
    return body.on('click', '.vacancies_list table a', function(event) {
        event.preventDefault();

        $.ajax(this.href, {
            type: 'DELETE',
            dataType: 'json',
            success: function(data) {
                if (vacancy_list.children('table.table.table-bordered.table-hover').length === 0) {
                    vacancy_list.append(JST['candidates/vacancies_table']({}));
                }
                $('ul.dropdown-menu', vacancy_list).append(JST['candidates/vacancies_list_row']({
                    name: data.vacancy_name,
                    set_vacancy: "/candidates/" + data.candidate_id + "/set_vacancies?vacancy_id=" + data.vacancy_id
                }));
                return $(event.target).closest('tr').remove();
            }
        });
        return false;
    });
});