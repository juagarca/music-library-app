class Album < ApplicationRecord
  belongs_to :artist
  has_many :albumSongs, dependent: :destroy
  has_many :userAlbums, dependent: :destroy
  has_many :songs, through: :albumSongs
  has_one_attached :cover

  validates :release_date, presence: true
end
