class Album < ApplicationRecord
  belongs_to :artist
  has_many :albumSongs, dependent: :destroy

  validates :release_date, presence: true
end
