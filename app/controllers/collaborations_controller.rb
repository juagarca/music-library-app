class CollaborationsController < ApplicationController
  def create
    # redirect_to
    parameters = collaboration_params
    song = Song.find(parameters[:song])
    collaborator = Artist.find(parameters[:artist])
    album_id = parameters[:album]
    singer_id = parameters[:singer]

    Collaboration.create(song: song, artist: collaborator)

    redirect_to artist_album_path(singer_id, album_id)
  end

  def collaboration_params
    params.require(:collaboration).permit(:song, :artist, :album, :singer)
  end
end
