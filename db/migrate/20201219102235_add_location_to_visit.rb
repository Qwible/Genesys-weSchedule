# frozen_string_literal: true

class AddLocationToVisit < ActiveRecord::Migration[6.0]
  def change
    add_column :visits, :location, :string
  end
end
