json.eventName link_to @event.name, @event
json.eventId @event.id
json.eventDate @event.will_begin_at.strftime('%e %b %H:%M')

sf = @event.staff_relation
if sf.present?
  json.vacancyLink sf.vacancy.present? ? (link_to sf.vacancy.name, vacancy_path(sf.vacancy_id)) : '------'
  json.candidateLink sf.candidate.present? ? (link_to sf.candidate.name, candidate_path(sf.candidate_id)) : '------'
else
  json.vacancyLink '------'
  json.candidateLink '------'
end
