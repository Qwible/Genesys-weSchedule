# == Schema Information
#
# Table name: calendar_events
#
#  id             :bigint           not null, primary key
#  auto_generated :boolean
#  event_end      :datetime
#  event_start    :datetime
#  late_alert     :boolean
#  task_id        :bigint
#
# Indexes
#
#  index_calendar_events_on_task_id  (task_id)
#
# Foreign Keys
#
#  fk_rails_...  (task_id => tasks.id)
#
class CalendarEvent < ApplicationRecord
  belongs_to :task
end
