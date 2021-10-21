class AddLockableToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :locked_at, :datetime
    add_column :users, :failed_attempts, :integer, :default => 0, null: false # Only if lock strategy is :failed_attempts
  end
end
