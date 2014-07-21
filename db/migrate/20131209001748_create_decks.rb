class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.integer :user_id
      t.string :title
      t.boolean :public
      t.string :subject
      t.string :description
      t.string :regex

      t.timestamps
    end
  end
end
