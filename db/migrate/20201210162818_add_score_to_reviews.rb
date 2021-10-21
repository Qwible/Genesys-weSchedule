# frozen_string_literal: true

class AddScoreToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :score, :integer
    change_column_default :reviews, :score, 0
  end
end
