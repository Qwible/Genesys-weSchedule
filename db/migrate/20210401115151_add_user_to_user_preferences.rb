class AddUserToUserPreferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :user_preferences, :user, null: false, foreign_key: true, index: true
  end
end
