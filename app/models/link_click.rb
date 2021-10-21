# frozen_string_literal: true

# == Schema Information
#
# Table name: link_clicks
#
#  id          :bigint           not null, primary key
#  link_name   :string
#  url         :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  link_css_id :string
#  visit_id    :bigint
#
# Indexes
#
#  index_link_clicks_on_link_css_id  (link_css_id)
#  index_link_clicks_on_visit_id     (visit_id)
#

class LinkClick < ApplicationRecord
  belongs_to :visit
end
