# == Schema Information
#
# Table name: feedbacks
#
#  id                :bigint           not null, primary key
#  comment           :text
#  feedback_category :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_feedbacks_on_feedback_category  (feedback_category)
#
class Feedback < ApplicationRecord
end
