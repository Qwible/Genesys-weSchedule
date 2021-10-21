# frozen_string_literal: true

class AddVisibleToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :visible, :boolean
  end
end
