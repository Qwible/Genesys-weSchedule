class ChangeIsPremiumToAccountType < ActiveRecord::Migration[6.0]
  def change
    remove_column :logins, :is_premium, :boolean, default: false
    add_column :logins, :account_type, :string
  end
end
