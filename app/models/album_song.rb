class AlbumSong < ApplicationRecord
  belongs_to :album
  belongs_to :song

  validates :track_number, presence: true
end
