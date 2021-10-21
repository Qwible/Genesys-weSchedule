class AddWeekendWorkingToUserPrefs < ActiveRecord::Migration[6.0]
  def change
    add_column :user_preferences, :weekends, :boolean
  end
end
