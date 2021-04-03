class Song < ApplicationRecord
  has_many :albumSongs
  # has_many :albums, through: :album_songs
  has_many :collaborations

  validates :length, presence: true
  validates :title, presence: true
end
