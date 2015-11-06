json.array!(@events) do |event|
  json.extract! event, :id, :name, :will_begin_at
  json.url event_url(event, format: :json)
end
