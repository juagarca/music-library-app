class AddDescriptionToArtists < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :description, :string
  end
end
