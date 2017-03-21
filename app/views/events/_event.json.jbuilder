# json.events(@events) do |data|
#   json.(data, :name)
#   json.(data, :description)
#   json.(data, :will_begin_at)
#
#   if data&.staff_relation&.vacancy&.name.present?
#     json.vacancy_name data.staff_relation.vacancy.name
#   else
#     json.vacancy_name '------'
#   end
#
#   if data&.staff_relation&.candidate&.name.present?
#     json.candidate_name data.staff_relation.candidate.name
#   else
#     json.candidate_name '------'
#   end
#
#   if can? :update, data
#     json.update_path '<a class="glyphicon glyphicon-edit" data-remote="true" href='"#{edit_event_path(data)}"'></a>'
#   else
#     json.update_path ''
#   end
#
#   if can? :delete, data
#     json.destroy_path '<a data-confirm="Вы уверены?" class="glyphicon glyphicon-remove" rel="nofollow" data-method="delete" href='"#{event_path(data)}"'></a>'
#   else
#     json.destroy_path ''
#   end
# end
json.(event, :name, :will_begin_at, :description)

if event&.staff_relation&.vacancy&.name.present?
  json.vacancy_name event.staff_relation.vacancy.name
else
  json.vacancy_name '------'
end

if event&.staff_relation&.candidate&.name.present?
  json.candidate_name event.staff_relation.candidate.name
else
  json.candidate_name '------'
end

if can? :update, event
  json.update_path '<a class="glyphicon glyphicon-edit" data-remote="true" href='"#{edit_event_path(event)}"'></a>'
else
  json.update_path ''
end

if can? :delete, event
  json.destroy_path '<a data-confirm="Вы уверены?" class="glyphicon glyphicon-remove" rel="nofollow" data-method="delete" href='"#{event_path(event)}"'></a>'
else
  json.destroy_path ''
end