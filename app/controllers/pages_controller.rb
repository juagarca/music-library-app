class PagesController < ApplicationController
  def dashboard
    @artists = current_user.artists
  end
end
