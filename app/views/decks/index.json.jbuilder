json.array!(@decks) do |deck|
  json.extract! deck, :user_id, :title, :public, :subject, :description, :regex
  json.url deck_url(deck, format: :json)
end
