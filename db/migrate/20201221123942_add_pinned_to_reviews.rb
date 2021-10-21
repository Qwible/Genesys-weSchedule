class AddPinnedToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :pinned, :boolean
    change_column_default :reviews, :pinned, false
  end
end
