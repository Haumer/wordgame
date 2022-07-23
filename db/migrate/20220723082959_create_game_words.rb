class CreateGameWords < ActiveRecord::Migration[7.0]
  def change
    create_table :game_words do |t|
      t.references :word, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
