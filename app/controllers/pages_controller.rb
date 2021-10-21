# frozen_string_literal: true

# Pages Controller
class PagesController < ApplicationController
  skip_authorization_check

  def home
    @current_nav_identifier = :home
  end

  def questions
    @current_nav_identifier = :questions
  end

  def contact
    @current_nav_identifier = :contact
    @feedbacks = Feedback.all
  end

  def metrics_feedback
    @current_nav_identifier = :metrics_feedback
    @positive_feedback = Feedback.where(feedback_category: 'positive').paginate(page: params[:page], per_page: 10)
    @negative_feedback = Feedback.where(feedback_category: 'negative').paginate(page: params[:page], per_page: 10)
    @neutral_feedback = Feedback.where.not(feedback_category: 'negative').where.not(feedback_category: 'positive').paginate(page: params[:page], per_page: 10)
  end

  def reviews
    @current_nav_identifier = :reviews
  end
end
