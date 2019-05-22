json.vacancy do
  json.(@vacancy, :id, :user_id, :status)
  json.status_class get_label_class(@vacancy.status)
end
json.vacancy_candidates @vacancy_candidates, :id, :name, :salary, :updated_at