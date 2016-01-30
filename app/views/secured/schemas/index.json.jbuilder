json.array!(@schemas) do |schema|
  json.extract! schema, :id
  json.url user_schema_url(schema, format: :json)
end
