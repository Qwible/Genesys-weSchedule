# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  answer     :string
#  date       :string
#  interest   :integer          default(0)
#  n_ratings  :integer          default(0)
#  score      :integer          default(0)
#  text       :string
#  visible    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_questions_on_interest  (interest)
#
class Question < ApplicationRecord
end
