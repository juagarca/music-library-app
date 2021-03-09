class PagesController < ApplicationController
  def artists
    @artists = Artist.all
  end
end
