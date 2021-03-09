class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :userArtists
  has_many :artists, through: :userArtists

  # validates :username, presence: true

  def find_artist(artist)
    artists.find { |a| artist == a }
  end
end
