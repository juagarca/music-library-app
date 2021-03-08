class CreateOutlists < ActiveRecord::Migration[6.0]
  def change
    create_table :outlists do |t|
      t.references :song, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :played

      t.timestamps
    end
  end
end
