class CreateArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :birth_location
      t.string :instagram
      t.string :bio

      t.timestamps
    end
  end
end
