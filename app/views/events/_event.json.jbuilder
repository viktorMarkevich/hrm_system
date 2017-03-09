json.(event, :name, :will_begin_at, :description)

json.vacancy_name event.try(:staff_relation).try(:vacancy).try(:name)
json.candidate_name event.try(:staff_relation).try(:candidate).try(:name)

if can? :update, event
  json.update_path edit_event_path(event)
end

if can? :delete, event
  json.destroy_path event_path(event)
end