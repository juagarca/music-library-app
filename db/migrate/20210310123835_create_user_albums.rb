class CreateUserAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :user_albums do |t|
      t.references :album, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :played

      t.timestamps
    end
  end
end
