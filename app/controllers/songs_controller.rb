class SongsController < ApplicationController
  before_action :set_song, only: %i[show edit update]

  def show
    @artist_id = params[:artist_id]
    @album_id = params[:album_id]
  end

  def edit
    @artist = Artist.find(params[:artist_id])
    @album = Album.find(params[:album_id])
  end

  def update
    @song.update(song_params)
    artist_id = params[:artist_id]
    album_id = params[:album_id]
    redirect_to artist_album_song_path(artist_id, album_id, @song)
  end

  private

  def set_song
    @song = Song.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:title, :length, :single, :video_url, :description)
  end
end
