class AddTypeToFeedback < ActiveRecord::Migration[6.0]
  def change
    add_column :feedbacks, :feedback_category, :string
  end
end
