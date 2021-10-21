# frozen_string_literal: true

class CreateLinkClicks < ActiveRecord::Migration[6.0]
  def change
    create_table :link_clicks do |t|
      t.references :visit, index: true
      t.string     :link_name
      t.string     :link_css_id
      t.text       :url
      t.timestamps null: false
    end
  end
end
