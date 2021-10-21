# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id         :bigint           not null, primary key
#  email      :string
#  tier       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_registrations_on_created_at  (created_at)
#  index_registrations_on_tier        (tier)
#
class Registration < ApplicationRecord
end
