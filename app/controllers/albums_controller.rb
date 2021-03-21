class AlbumsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @album = Album.find(params[:id])
    @artist = @album.artist
    @songs = @album.songs
    @artists = Artist.all
    @collaboration = Collaboration.new
  end


end
