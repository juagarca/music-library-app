class Artist < ApplicationRecord
  has_many :userArtists, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :songs, through: :collaborations, as: :collaborations, dependent: :destroy
  has_many :performer_artists
  has_many :performers, through: :performer_artists

  validates :name, presence: true
end
