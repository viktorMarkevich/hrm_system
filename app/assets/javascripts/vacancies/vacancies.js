// coding 'utf-8'
//= require vacancies/vacancies_candidate_table
//= require vacancies/vacancies_candidate_row
//= require vacancies/vacancies_no_candidates
//= require vacancies/candidates_modal_form
//= require vacancies/candidates_modal_row
//= require vacancies/candidates_modal_staff_relation_row
//= require vacancies/candidates_modal_candidate_status_row

var renderVacancyCandidates;
var vacancy_candidates_content = $('.vacancy-candidates .content');

renderVacancyCandidates = function(data) {
    vacancy_candidates_content.empty();
    if (data.vacancy_candidates.length !== 0) {
        vacancy_candidates_content.append(JST['vacancies/vacancies_candidate_table']);
        return $.each(data.vacancy_candidates, function(i, candidate) {
            var updated_at;
            updated_at = new Date(candidate.updated_at);
            $('tbody', vacancy_candidates_content).append(JST['vacancies/vacancies_candidate_row']({
                candidate_id: candidate.id,
                candidate_name: candidate.name,
                candidate_salary: candidate.salary,
                candidate_updated_at: updated_at.toISOString().slice(0, 10),
                vacancy_id: data.vacancy.id,
                vacancy_user_id: data.vacancy.user_id
            }));
        });
    } else {
        return vacancy_candidates_content.append(JST['vacancies/vacancies_no_candidates']);
    }
};

$(document).ready(function() {

    var body = $('body');
    var dialog = $('#dialog');
    var params = {
        vacancy: {
            candidate_id: $(this).closest('form').find('#vacancy_candidate_id').val(),
            user_id: $(this).closest('form').find('#vacancy_user_id').val(),
            sr_status: $(this).val()
        }
    };

    body.on('change', '.vacancy_sr_status', function() {
        return $.ajax($(this).closest('form').attr('action'), {
            data: params,
            type: 'PUT',
            dataType: 'json',
            success: function(data) {
                return renderVacancyCandidates(data);
            }
        });
    });
    body.on('click', '.vacancy-candidates a.btn', function(event) {
        event.preventDefault();
        $.ajax(this.href, {
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                return renderVacancyCandidates(data);
            }
        });
        return false;
    });
    body.on('click', '.staff-relation', function(event) {

        var modal_body = $('.modal-body');

        event.preventDefault();
        $.ajax(this.href, {
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                modal_body.empty();
                modal_body.append(JST['vacancies/candidates_modal_form']({
                    vacancy_id: data.id
                }));
                $.each(data.candidates, function(i, candidate) {
                    $('tbody', modal_body).append(JST['vacancies/candidates_modal_row']({
                        candidate_id: candidate.id,
                        candidate_name: candidate.name,
                        candidate_salary: candidate.salary
                    }));
                    if (candidate.staff_relations.length !== 0) {
                        $.each(candidate.staff_relations, function(i, staff_relation) {
                            $(".modal-body .candidate_" + candidate.id + " .staff_relations").append(JST['vacancies/candidates_modal_staff_relation_row']({
                                staff_realation_status: staff_relation.status,
                                staff_realation_vacancy_name: staff_relation.vacancy_name
                            }));
                        });
                    } else {
                        return $(".modal-body .candidate_" + candidate.id + " .staff_relations").append(JST['vacancies/candidates_modal_candidate_status_row']({
                            staff_realation_status: candidate.status
                        }));
                    }
                });
                return dialog.modal('show');
            }
        });
        return false;
    });
    return body.on('click', '.modal-body input[type=submit]', function(event) {
        event.preventDefault();

        var spant = $('spant');
        var candidates = [];
        var vacancy_id = $('#staff_relation_vacancy_id').val();
        var params = {
            staff_relation: {
                vacancy_id: vacancy_id,
                candidate_id: candidates
            },
            commit: 'Выполнить'
        };

        $('.new_staff_relation input:checked').each(function() {
            return candidates.push($(this).val());
        });
        $.ajax($(this).closest('form').attr('action'), {
            data: params,
            type: 'POST',
            dataType: 'json',
            success: function(data) {
                renderVacancyCandidates(data);
                dialog.modal('hide');
                spant.text(data.vacancy.status);
                console.log(data);
                return spant.removeClass().addClass("label " + data.vacancy.status_class);
            }
        });
        return false;
    });
});