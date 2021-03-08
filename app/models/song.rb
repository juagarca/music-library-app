class Song < ApplicationRecord
  has_many :albumsongs
  has_many :outlists
  has_many :collaborations

  validates :length, presence: true
  validates :title, presence: true
end
