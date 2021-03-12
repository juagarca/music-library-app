class DeletePerformerArtistForeignKeyFromArtists < ActiveRecord::Migration[6.0]
  def change
    remove_column :artists, :performer_artists_id
  end
end
