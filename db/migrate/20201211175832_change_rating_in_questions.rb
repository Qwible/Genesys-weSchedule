# frozen_string_literal: true

class ChangeRatingInQuestions < ActiveRecord::Migration[6.0]
  def change
    change_column :questions, :rating, :int, using: 'rating::integer'
    rename_column :questions, :rating, :n_ratings
  end
end
