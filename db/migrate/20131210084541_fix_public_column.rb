class FixPublicColumn < ActiveRecord::Migration
  def change
    rename_column :decks, :public, :public_deck
  end
end
