# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :anonymous
      t.text :review

      t.timestamps
    end
  end
end
