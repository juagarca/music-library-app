class AddPerformersToArtists < ActiveRecord::Migration[6.0]
  def change
    add_reference :artists, :performer_artists, foreign_key: true
  end
end
