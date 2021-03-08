class CreateLibraries < ActiveRecord::Migration[6.0]
  def change
    create_table :libraries do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
