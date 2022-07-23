class Batch < ApplicationRecord
  belongs_to :user
  has_many :batch_words, dependent: :destroy
  has_many :words, through: :batch_words
end
