json.array!(@schemas) do |schema|
  json.extract! schema, :id
  json.url admin_schema_url(schema, format: :json)
end
