# frozen_string_literal: true

class AddTimestampsToVisits < ActiveRecord::Migration[6.0]
  def change
    add_column :visits, :created_at, :datetime, null: false
    add_column :visits, :updated_at, :datetime, null: false
  end
end
