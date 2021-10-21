# frozen_string_literal: true

class AddHiddenToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :hidden, :boolean
    change_column_default :reviews, :hidden, false
  end
end
