class AddStartAndEndToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :start_datetime, :datetime
    add_column :tasks, :end_datetime, :datetime
  end
end
