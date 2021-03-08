class AddDefaultToOutlistPlayed < ActiveRecord::Migration[6.0]
  def change
    change_column :outlists, :played, :boolean, :default => false
  end
end
