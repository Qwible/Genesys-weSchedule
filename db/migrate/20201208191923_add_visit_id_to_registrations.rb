# frozen_string_literal: true

class AddVisitIdToRegistrations < ActiveRecord::Migration[5.0]
  def change
    add_column :visits, :registration_id, :integer, index: true
  end
end
