class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.boolean :single
      t.string :video_url
      t.integer :length
      t.string :description

      t.timestamps
    end
  end
end
