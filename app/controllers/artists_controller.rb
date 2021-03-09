class ArtistsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @artists = Artist.all
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def add
    @artist = Artist.find(params[:artist_id])
    picked = UserArtist.find_by(artist: @artist)
    if picked
      picked.destroy
    else
      UserArtist.create!(user: current_user, artist: @artist)
    end
    redirect_to artists_path
  end
end
