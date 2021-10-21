class FixColumnNameIsPremiumInLogins < ActiveRecord::Migration[6.0]
  def change
    remove_column :logins, :isPremium
    add_column :logins, :is_premium, :boolean, default: false
  end
end
