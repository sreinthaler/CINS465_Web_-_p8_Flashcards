class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :deck_id
      t.integer :deck_card_id
      t.string :front
      t.string :back
      t.string :regex

      t.timestamps
    end
  end
end
