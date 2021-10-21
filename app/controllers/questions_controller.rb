# frozen_string_literal: true

# Handles requests to retrieve or change question data
class QuestionsController < ApplicationController
  before_action :set_question, only: %i[update hide_and_unhide increase_score
                                        decrease_score express_interest]
  # GET /questions
  def index
    @order = params[:order]
    @questions = if params[:order] && params[:order] != 'Date Descending'
                   sort_questions(params[:order])
                 else
                   Question.accessible_by(current_ability).reverse
                 end
    @questions = @questions.paginate(page: params[:page], per_page: 10)
  end

  # POST /questions
  def create
    # this works for .new and .create as well
    @question = Question.new(question_params) do |a|
      a.date = current_date
    end
    if @question.save
      redirect_to :questions, notice: 'Question was successfully created.'
    else
      redirect_to :questions
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params_admin)
      redirect_to :questions, notice: 'Answer was successfully created.'
    else
      redirect_to :questions
    end
  end

  # Increase the score for a given answer based on a user rating
  # POST: /questions/:id/increase_score
  def increase_score
    # Check the current session for an existing rating as we don't want users to need to sign in to rate questions
    last_rating = check_prev('question_ratings')
    # Respond appropriately to the situation
    # JSON response fields:
    # old_rating: Was there a rating in the session for this question?
    # rating_change: as a result of the action did the rating for this question change
    # alert: Unused, useful for front-end debugging
    # new_score: only set if rating_change == true, contains the updated score for the question
    if last_rating.nil?
      # If no existing rating exists in this session, proceed as normal
      submit_question_score('positive')
    elsif last_rating == 'positive'
      # If an existing positive rating exists in the session, return JSON without changing anything
      render json: { old_rating: true, rating_change: false,
                     alert: 'You have already submitted a rating for this question' }
    else
      # If an existing negative rating exists, reverse that rating and save it
      # a +ve rating counts as +1 score while a negative rating is -1,
      # so undoing a -ve rating and applying a +ve one gives +2
      flip_question_score('positive')
    end
  end

  # Decrease the score for a given question based on a user rating
  # POST: /questions/:id/decrease_score
  def decrease_score
    # Check the current session for an existing rating as we don't want users to need to sign in to rate questions
    last_rating = check_prev('question_ratings')
    # Respond appropriately to the situation
    # JSON response fields:
    # old_rating: Was there a rating in the session for this question?
    # rating_change: as a result of the action did the rating for this question change
    # alert: Unused, useful for front-end debugging
    # new_score: only set if rating_change == true, contains the updated score for the question
    if last_rating.nil?
      # If no existing rating exists in this session, proceed as normal
      submit_question_score('negative')
    elsif last_rating == 'negative'
      # If an existing negative rating exists in the session, return JSON without changing anything
      render json: { old_rating: true, rating_change: false,
                     alert: 'You have already submitted a rating for this question' }
    else
      # If an existing positive rating exists, reverse that rating and save it
      # a -ve rating counts as -1 score while a +ve rating is +1,
      # so undoing a +ve rating and applying a -ve one gives -2
      flip_question_score('negative')
    end
  end

  # Toggle the hidden attribute for the question in the url
  # POST: /questions/:id/hide_and_unhide
  def hide_and_unhide
    @question.update_attribute(:visible, !@question.visible)
    # Json response for AJAX
    render json: { response: 'question was successfully hidden/unhidden.' }
  end

  # Allows the user to express their interest in the question
  # POST: /questions/:id/express_interest
  def express_interest
    prev_interest = check_prev('question_interest')
    if prev_interest.nil?
      session['question_interest'][@question.id.to_s] = 'Not null'
      new_interest = @question.interest + 1
      @question.update_attribute(:interest, new_interest)
      render  json: { response: true, new_score: new_interest }
    else
      render  json: { response: false }
    end
  end

  private

  def sort_questions(order)
    questions = case order
                when 'Interest Descending'
                  Question.accessible_by(current_ability).sort_by(&:interest).reverse
                when 'Date Ascending'
                  Question.accessible_by(current_ability)
                else
                  Question.accessible_by(current_ability).sort_by(&:interest)
                end
    questions
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  # Only allow a trusted parameter 'white list' through.
  def question_params
    params.require(:question).permit(:text)
  end

  def question_params_admin
    params.require(:question).permit(:text, :answer)
  end

  def current_date
    d = DateTime.now
    d.strftime('%d/%m/%Y %H:%M')
    d
  end

  def check_prev(hashname)
    if !session[hashname].nil?
      prev = session[hashname][@question.id.to_s]
    else
      session[hashname] = {}
      prev = nil
    end
    prev
  end

  def submit_question_score(direction)
    new_score = direction == 'positive' ? @question.score + 1 : @question.score - 1
    @question.update_attribute(:score, new_score)
    new_n_ratings = @question.n_ratings + 1
    @question.update_attribute(:n_ratings, new_n_ratings)
    # Set session variable for future ratings for this question
    session['question_ratings'][@question.id.to_s] = direction
    # Return JSON so AJAX frontend can behave as expected
    render json: { old_rating: false, rating_change: true, alert: 'Feedback submitted successfully',
                   new_score: new_score, new_n_ratings: new_n_ratings }
  end

  def flip_question_score(direction)
    new_score = direction == 'positive' ? @question.score + 2 : @question.score - 2
    @question.update_attribute(:score, new_score)
    # Set session variable for future questions
    session['question_ratings'][@question.id.to_s] = direction
    # Return JSON so AJAX frontend can behave as expected
    render json: { old_rating: true, rating_change: true,
                   alert: 'Feedback submitted successfully', new_score: new_score }
  end
end
