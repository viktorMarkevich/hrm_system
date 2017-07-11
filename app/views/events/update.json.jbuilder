json.eventName @event.name
json.eventId @event.id
if @event.staff_relation.present?
  json.vacancyLink link_to @event.staff_relation.vacancy.name, vacancy_path(@event.staff_relation.vacancy_id)
  json.candidateLink link_to @event.staff_relation.candidate.name, candidate_path(@event.staff_relation.candidate_id)
else
  json.vacancyLink '------'
  json.candidateLink '------'
end
json.eventData @event.will_begin_at.strftime('%e %b %H:%M')
