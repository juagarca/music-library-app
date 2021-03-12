class DeleteLastnameFromPerformers < ActiveRecord::Migration[6.0]
  def change
    remove_column :performers, :last_name
    rename_column :performers, :first_name, :full_name
  end
end
