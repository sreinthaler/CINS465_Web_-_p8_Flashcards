json.array!(@tags) do |tag|
  json.extract! tag, :deck_id, :tag_string
  json.url tag_url(tag, format: :json)
end
