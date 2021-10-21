class AddIndicesToTables < ActiveRecord::Migration[6.0]
  def change
    add_index :feedbacks, :feedback_category
    add_index :visits, :created_at
    add_index :questions, :interest
    add_index :registrations, :tier
    add_index :registrations, :created_at
    add_index :reviews, :pinned
    add_index :reviews, :hidden
    add_index :reviews, :created_at
    add_index :reviews, :score
    add_index :link_clicks, :link_css_id
  end
end
