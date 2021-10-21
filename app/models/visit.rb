# frozen_string_literal: true

# == Schema Information
#
# Table name: visits
#
#  id              :bigint           not null, primary key
#  location        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  registration_id :integer
#
# Indexes
#
#  index_visits_on_created_at  (created_at)
#

class Visit < ApplicationRecord
  has_many :link_clicks, -> { where.not(url: nil).order(created_at: :asc) }
  belongs_to :registration, optional: true
end
