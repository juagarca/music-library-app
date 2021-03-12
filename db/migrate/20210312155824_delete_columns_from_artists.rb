class DeleteColumnsFromArtists < ActiveRecord::Migration[6.0]
  def change
    remove_column :artists, :first_name
    remove_column :artists, :last_name
    remove_column :artists, :date_of_birth
    remove_column :artists, :birth_location
  end
end
