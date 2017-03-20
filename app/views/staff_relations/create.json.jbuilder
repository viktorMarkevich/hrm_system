json.vacancy do
  json.(@vacancy, :id, :user_id, :status)
  json.status_class @vacancy_status_class
end
json.vacancy_candidates @vacancy_candidates, :id, :name, :salary, :updated_at