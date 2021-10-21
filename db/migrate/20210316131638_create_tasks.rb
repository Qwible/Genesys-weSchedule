class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.date :startDate
      t.date :endDate
      t.integer :length
      t.integer :priority
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
