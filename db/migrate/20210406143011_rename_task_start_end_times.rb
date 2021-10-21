class RenameTaskStartEndTimes < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :startDate, :start_datetime
    rename_column :tasks, :endDate, :end_datetime
  end
end
