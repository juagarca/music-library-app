class Song < ApplicationRecord
  has_many :albumSongs
  has_many :collaborations

  validates :length, presence: true
  validates :title, presence: true
end
