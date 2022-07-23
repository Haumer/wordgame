module ApplicationHelper
  def new_word?(word, batch)
    'new-word' if word.batch_words.first.created_at == word.batch_words.find_by(batch_id: batch.id).created_at
  end
end
