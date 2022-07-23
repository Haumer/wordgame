class Word < ApplicationRecord
  has_many :game_words
  has_many :games
  belongs_to :user
  has_many :batch_words, dependent: :destroy
end
