class DashboardsController < ApplicationController
  def user
    @artists = current_user.artists
  end
end
