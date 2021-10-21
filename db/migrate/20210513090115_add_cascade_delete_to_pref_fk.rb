class AddCascadeDeleteToPrefFk < ActiveRecord::Migration[6.0]
  def change
    UserPreference.destroy_all
    Task.destroy_all
    remove_reference :tasks, :user, foreign_key: true
    remove_reference :user_preferences, :user, null: false, foreign_key: true, index: true
    User.destroy_all
    add_reference :tasks, :user, null: false, foreign_key: { on_delete: :cascade }, index: true
    add_reference :user_preferences, :user, null: false, foreign_key: { on_delete: :cascade }, index: true
  end
end
