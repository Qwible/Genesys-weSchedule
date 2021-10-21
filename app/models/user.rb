# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  account_type           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :registerable, :lockable
  after_save :create_preferences
  
  after_create do |user|
    save_unique_login
  end
  
  def after_database_authentication
    save_unique_login
  end

  def create_preferences
    up = UserPreference.find_by(user_id: self.id)
    if(up == nil)
      if(self.account_type == "Pro" || self.account_type == "Student")
        user_preference = UserPreference.new
        user_preference.workday_start = 9*60*60
        user_preference.workday_end = 17*60*60
        user_preference.alternating_tasks = false
        user_preference.user_id = self.id
        user_preference.save
      end
    end
  end
  
  
  def save_unique_login
    today = UtcDay.get_current_utc_day
    currentDayLogin = Login.where(email: email, day: today).first

    if currentDayLogin.nil?
      to_store_user = User.where(email: email).first
      if !to_store_user.account_type.nil? && to_store_user.account_type != AccountType::ADMIN
        Login.create(email: email, day: today, account_type: account_type)
      end
    end
  end
end
