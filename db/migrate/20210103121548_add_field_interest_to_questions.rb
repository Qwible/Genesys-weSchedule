# frozen_string_literal: true

class AddFieldInterestToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :interest, :int
  end
end
