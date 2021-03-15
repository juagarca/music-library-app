class AddDefaultToSongsSingleColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :songs, :single, :boolean, default: false
  end
end
