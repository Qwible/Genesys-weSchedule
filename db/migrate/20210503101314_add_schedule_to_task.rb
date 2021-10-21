class AddScheduleToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :schedule, :boolean, :default => false
  end
end
