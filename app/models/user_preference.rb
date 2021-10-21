# == Schema Information
#
# Table name: user_preferences
#
#  id                :bigint           not null, primary key
#  alternating_tasks :boolean
#  weekends          :boolean          default(FALSE)
#  workday_end       :integer
#  workday_start     :integer
#  user_id           :bigint           not null
#
# Indexes
#
#  index_user_preferences_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class UserPreference < ApplicationRecord
end
