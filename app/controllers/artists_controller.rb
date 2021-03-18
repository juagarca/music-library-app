class ArtistsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @artists = Artist.all
  end

  def show
    @artist = Artist.find(params[:id])
    @albums = @artist.albums.where(category: 'album')
    @other_releases = @artist.albums.where(category: 'other')
  end

  def add
    artist = Artist.find(params[:artist_id])
    picked = UserArtist.where(artist: artist, user: current_user).first
    if picked
      picked.destroy
      delete_albums_from_user_dashboard(artist)
    else
      UserArtist.create(user: current_user, artist: artist)
      add_albums_to_user_dashboard(artist)
    end
    redirect_to artists_path
  end

  private

  def delete_albums_from_user_dashboard(artist)
    artist.albums.each do |album|
      UserAlbum.where(album_id: album.id, user: current_user).destroy_all
    end
  end

  def add_albums_to_user_dashboard(artist)
    artist.albums.each do |album|
      UserAlbum.create(user: current_user, album: album)
    end
  end
end
