class Artist < ApplicationRecord
  has_many :userArtists, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :songs, through: :collaborations, as: :collaborations, dependent: :destroy

  validates :name, presence: true
end
