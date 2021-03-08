class Artist < ApplicationRecord
  has_many :libraries
  has_many :collaborations
  has_many :albums
  has_many :songs, through: :collaborations, as: :collaborations

  validates :name, presence: true
end
