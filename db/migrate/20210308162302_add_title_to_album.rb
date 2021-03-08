class AddTitleToAlbum < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :title, :string
  end
end
