class CreateLogins < ActiveRecord::Migration[6.0]
  def change
    create_table :logins do |t|
      t.string :email
      t.integer :day
      t.boolean :isPremium

      t.timestamps
    end
  end
end
