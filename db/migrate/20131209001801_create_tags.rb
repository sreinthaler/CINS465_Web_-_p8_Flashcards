class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :deck_id
      t.string :tag_string

      t.timestamps
    end
  end
end
