# == Schema Information
#
# Table name: calendar_events
#
#  id             :integer          not null, primary key
#  auto_generated :boolean
#  event_end      :datetime
#  event_start    :datetime
#  late_alert     :boolean
#  task_id        :integer
#
# Indexes
#
#  index_calendar_events_on_task_id  (task_id)
#
# Foreign Keys
#
#  task_id  (task_id => tasks.id)
#
class CalendarEvent < ApplicationRecord
  belongs_to :task
end
