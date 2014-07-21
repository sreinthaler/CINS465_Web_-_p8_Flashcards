json.array!(@cards) do |card|
  json.extract! card, :deck_id, :deck_card_id, :front, :back, :regex
  json.url card_url(card, format: :json)
end
