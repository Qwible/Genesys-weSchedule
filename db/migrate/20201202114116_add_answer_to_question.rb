# frozen_string_literal: true

class AddAnswerToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :answer, :string
  end
end
