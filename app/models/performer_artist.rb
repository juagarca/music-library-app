class PerformerArtist < ApplicationRecord
  belongs_to :performer
  belongs_to :artist
end
