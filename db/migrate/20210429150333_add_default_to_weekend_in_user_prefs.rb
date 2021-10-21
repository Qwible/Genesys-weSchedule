class AddDefaultToWeekendInUserPrefs < ActiveRecord::Migration[6.0]
  def up
    change_column_default :user_preferences, :weekends, false
  end

  def down
    change_column_default :user_preferences, :weekends, nil
  end
end
