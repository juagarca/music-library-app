class Album < ApplicationRecord
  belongs_to :artist
  has_many :tracklists

  validates :release_date
end
