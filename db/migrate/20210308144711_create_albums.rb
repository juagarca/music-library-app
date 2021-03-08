class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.references :artist, null: false, foreign_key: true
      t.date :release_date
      t.string :description

      t.timestamps
    end
  end
end
