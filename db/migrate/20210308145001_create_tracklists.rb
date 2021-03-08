class CreateTracklists < ActiveRecord::Migration[6.0]
  def change
    create_table :tracklists do |t|
      t.references :album, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true

      t.timestamps
    end
  end
end
