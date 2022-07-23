class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :google_sheet
  has_many :batches, dependent: :destroy
  has_many :words, through: :batches

  validates :sheet_url, presence: true, on: :update
end
