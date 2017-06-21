# json.(@staff_relation, :id)

json.(@vacancy, :id)

json.candidates(@candidates) do |candidate|
  json.id candidate.id
  json.name candidate.name
  json.salary candidate.salary
  json.status candidate.status
  json.staff_relations(candidate.staff_relations) do |staff_relation|
    json.status staff_relation.status
    json.vacancy_name staff_relation.vacancy&.name||'(Удалена)'
  end
end

