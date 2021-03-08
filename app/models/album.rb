class Album < ApplicationRecord
  belongs_to :artist
  has_many :albumsongs

  validates :release_date
end
