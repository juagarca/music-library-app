class AddFalseByDefaultToUserAlbumsPlayed < ActiveRecord::Migration[6.0]
  def change
    change_column :user_albums, :played, :boolean, default: false
  end
end
