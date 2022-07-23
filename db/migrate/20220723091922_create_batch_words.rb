class CreateBatchWords < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_words do |t|
      t.references :batch, null: false, foreign_key: true
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end
  end
end
