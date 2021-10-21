class RemoveStartAndEndFromTask < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :start_datetime, :date
    remove_column :tasks, :end_datetime, :date
  end
end
