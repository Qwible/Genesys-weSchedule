# == Schema Information
#
# Table name: tasks
#
#  id             :integer          not null, primary key
#  end_datetime   :datetime
#  length         :integer
#  name           :string
#  priority       :integer
#  schedule       :boolean          default(FALSE)
#  start_datetime :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_tasks_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id) ON DELETE => cascade
#
class Task < ApplicationRecord
    belongs_to :user
    has_many :calendar_events, dependent: :destroy
end
