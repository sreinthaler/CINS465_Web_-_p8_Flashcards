class Removecolumn < ActiveRecord::Migration
  def change
    remove_column :decks, :regex
  end
end
