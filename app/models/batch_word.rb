class BatchWord < ApplicationRecord
  belongs_to :batch
  belongs_to :word
end
