class CreatePerformerArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :performer_artists do |t|
      t.references :performer, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
