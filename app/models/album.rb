class Album < ApplicationRecord
  belongs_to :artist
  has_many :albumsongs

  validates :release_date, presence: true
  validates :title, presence: true
end
