class RenameTypeToCategory < ActiveRecord::Migration[6.0]
  def change
    rename_column :albums, :type, :category
  end
end
