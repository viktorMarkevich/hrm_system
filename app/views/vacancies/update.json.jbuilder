json.vacancy do
  json.(@vacancy, :id, :user_id)
end
json.vacancy_candidates @vacancy_candidates, :id, :name, :salary, :updated_at