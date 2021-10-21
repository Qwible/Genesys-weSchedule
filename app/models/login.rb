# == Schema Information
#
# Table name: logins
#
#  id           :bigint           not null, primary key
#  account_type :string
#  day          :integer
#  email        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Login < ApplicationRecord
end
