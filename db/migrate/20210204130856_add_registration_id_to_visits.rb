class AddRegistrationIdToVisits < ActiveRecord::Migration[6.0]
  def change
    add_column :visits, :registration_id, :integer, index: true
  end
end
