# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  anonymous  :boolean
#  first_name :string           not null
#  hidden     :boolean          default(FALSE)
#  last_name  :string           not null
#  pinned     :boolean          default(FALSE)
#  review     :text             not null
#  score      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reviews_on_created_at  (created_at)
#  index_reviews_on_hidden      (hidden)
#  index_reviews_on_pinned      (pinned)
#  index_reviews_on_score       (score)
#
class Review < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :review, presence: true
end
