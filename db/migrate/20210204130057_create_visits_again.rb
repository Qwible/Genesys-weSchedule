class CreateVisitsAgain < ActiveRecord::Migration[6.0]
  def change
    create_table :visits do |t|
      t.timestamps null: false
      t.string :location
    end
  end
end
