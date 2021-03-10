class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]

  def home
  end

  def dashboard
    @artists = current_user.artists
    @albums_to_listen = find_albums_to_listen
  end

  private

  def find_albums_to_listen
    records = UserAlbum.where(played: false)
    records.map do |record|
      record.album
    end
  end
end
