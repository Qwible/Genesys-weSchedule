class CreateCalendarEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :calendar_events do |t|
      t.datetime :event_start
      t.datetime :event_end
      t.belongs_to :task, foreign_key: true
    end
  end
end
