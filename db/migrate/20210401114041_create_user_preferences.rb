class CreateUserPreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :user_preferences do |t|
      t.integer :workday_start
      t.integer :workday_end
      t.boolean :alternating_tasks
    end
  end
end
