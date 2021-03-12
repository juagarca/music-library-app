class CreatePerformers < ActiveRecord::Migration[6.0]
  def change
    create_table :performers do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :birth_location

      t.timestamps
    end
  end
end
