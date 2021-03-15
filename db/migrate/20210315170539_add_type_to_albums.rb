class AddTypeToAlbums < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :type, :string
  end
end
