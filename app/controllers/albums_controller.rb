class AlbumsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @album = Album.find(params[:id])
    @songs = @album.songs
  end
end
