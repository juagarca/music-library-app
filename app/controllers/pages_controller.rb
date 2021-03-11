class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]

  def home
  end

  def dashboard
    @artists = current_user.artists
    @albums_to_listen = find_albums_to_listen
  end

  def tick
    record = UserAlbum.where(album: params[:id], user: current_user)
    record.update(played: true)
    redirect_to :dashboard
  end

  private

  def find_albums_to_listen
    records = UserAlbum.where(played: false, user: current_user)
    records.map do |record|
      record.album
    end
  end
end
