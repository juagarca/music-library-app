class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]

  def home
  end

  def dashboard
    @artists = current_user.artists
    @albums_to_listen = find_albums_to_listen(@artists)
  end

  private

  def find_albums_to_listen(artists)
    albums = []
    artists.each do |artist|
      albums << artist.albums.select do |album|
        album.release_date <= Date.today
      end
    end
    albums.flatten
  end
end
