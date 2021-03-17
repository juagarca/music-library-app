class Performer < ApplicationRecord
  has_many :performer_artists
  has_many :artists, through: :performer_artists
end
