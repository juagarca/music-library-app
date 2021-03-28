class PerformersController < ApplicationController
  before_action :set_performer, only: %i[show edit update]

  def index
    @performers = Performer.all
  end

  def show
  end

  def edit
  end

  def update
    @performer.update(performer_params)
    redirect_to performer_path
  end

  private

  def set_performer
    @performer = Performer.find(params[:id])
  end

  def performer_params
    params.require(:performer).permit(:full_name, :date_of_birth, :birth_location)
  end
end
