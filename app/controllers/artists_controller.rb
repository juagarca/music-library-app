class ArtistsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_artist, only: %i[show edit update]

  def index
    @artists = Artist.all
  end

  def show
    @albums = @artist.albums.where(category: 'album')
    @other_releases = @artist.albums.where.not(category: 'album')
  end

  def edit
  end

  def update
    @artist.update(artist_params)
    redirect_to artist_path(@artist)
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

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :instagram, :bio, photos: [])
  end
end
