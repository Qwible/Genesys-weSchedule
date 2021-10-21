# frozen_string_literal: true

class SetNilConstraintsOnReviews < ActiveRecord::Migration[6.0]
  def change
    change_column_null :reviews, :first_name, false, 'first'
    change_column_null :reviews, :last_name, false, 'last'
    change_column_null :reviews, :review, false, 'This used to be empty'
  end
end
