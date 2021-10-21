class AddDefaultValuesToQuestions < ActiveRecord::Migration[6.0]
  def change
    change_column :questions, :score, :integer, :default => 0
    change_column :questions, :interest, :integer, :default => 0
    change_column :questions, :visible, :boolean, :default => true
    change_column :questions, :n_ratings, :integer, :default => 0
  end
end
