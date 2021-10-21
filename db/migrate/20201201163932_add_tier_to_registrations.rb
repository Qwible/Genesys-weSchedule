# frozen_string_literal: true

class AddTierToRegistrations < ActiveRecord::Migration[6.0]
  def change
    add_column :registrations, :tier, :string
  end
end
