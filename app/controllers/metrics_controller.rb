# frozen_string_literal: true

class MetricsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def index
    @visits = Visit.includes(:link_clicks).includes(:registration).order('created_at DESC').uniq.paginate(page: params[:page], per_page: 10)
    @registrations = Registration.all.paginate(page: params[:page], per_page: 30)
    @current_page = "index"
  end

  def maps
    @current_page = 'maps'
  end

  def users
    @current_page = 'users'
    @daily_avg_total = get_average_daily_total_all_accounts

    @daily_avg_free = get_average_daily_total_for_account_type(AccountType::FREE)

    @daily_avg_premium = get_average_daily_total_for_account_type(AccountType::PREMIUM)

    @daily_avg_student = get_average_daily_total_for_account_type(AccountType::STUDENT)
  end

  def feedback
    @current_page = 'feedback'
    @positive_feedback = Feedback.where({feedback_category:'Positive'}).paginate(page: params[:page], per_page: 10)
    @negative_feedback = Feedback.where({feedback_category: 'Negative'}).paginate(page: params[:page], per_page: 10)
    @neutral_feedback = Feedback.where({feedback_category: 'Neutral'}).paginate(page: params[:page], per_page: 10)
  end


  def user_logins_chart
    chart_data = Login.where('created_at >= ?', 29.days.ago.beginning_of_day).group(:account_type).group_by_day(:created_at, range: 29.days.ago.midnight..Time.now).count
    render json: chart_data.chart_json
  end

  private
    def get_average_daily_total_all_accounts
      hash_count = Login.all.group_by_day(:created_at, range: 29.days.ago.midnight..Time.now).count
      array_count = hash_count.values.flatten
      return (array_count.sum.to_f/array_count.size.to_f)
    end

    def get_average_daily_total_for_account_type(account_type)
      hash_count = Login.where(account_type: account_type).group_by_day(:created_at, range: 29.days.ago.midnight..Time.now).count
      array_count = hash_count.values.flatten
      return (array_count.sum.to_f/array_count.size.to_f)
    end

    def admin_only
      unless can? :read, Visit
        redirect_to '/', :alert => "Access denied."
      end
    end
end
