# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :set_review, only: %i[hide_and_unhide increase_score decrease_score pin_review]
  before_action :set_review_count, only: %i[index]
  before_action :set_total_pages, only: %i[index]
  before_action :authenticate_user!, only: %i[hide_and_unhide pin_review]
  before_action :set_current_ordering, only: %i[index]
  before_action :set_current_page, only: %i[index]

  REVIEWS_PER_PAGE = 10
  POSITIVE_STRING = 'positive'
  NEGATIVE_STRING = 'negative'

  # GET /reviews
  def index
    @reviews = get_reviews_for_ordering_and_page(@current_ordering, @current_page)
    @reviews_per_page = REVIEWS_PER_PAGE
    @pinned_review_count = Review.where({ pinned: true }).count
    @pinned_reviews = Review.where({ pinned: true })
  end

  # POST /reviews
  def create
    # Needed because rspec doesn't validate frontend forms
    first_name, last_name, review = validate_inputs(review_params)

    @review = Review.new
    @review.first_name = first_name
    @review.last_name = last_name
    @review.review = review
    @review.anonymous = review_params[:anonymous]

    if @review.save
      redirect_to '/reviews', notice: 'Review was successfully created.'
    else
      redirect_to '/reviews', alert: 'Submission failed, please check your inputs and try again'
    end
  end

  # Toggle the hidden attribute for the review in the url
  # POST: /reviews/:id/hide_and_unhide
  def hide_and_unhide
    new_hidden_val = !@review.hidden
    @review.update(hidden: new_hidden_val)

    # Json response for AJAX
    render json: { response: 'Review was successfully hidden/unhidden.' }
  end

  # Increase the score for a given review based on a user rating
  # POST: /reviews/:id/increase_score
  def increase_score
    # Check the current session for an existing rating as we don't want users to need to sign in to rate reviews
    last_rating = nil

    if !session['review_ratings'].nil?
      last_rating = session['review_ratings'][@review.id.to_s]
    else
      session['review_ratings'] = {}
    end

    # Respond appropriately to the situation
    # JSON response fields:
    # old_rating: Was there a rating in the session for this review?
    # rating_change: as a result of the action did the rating for this review change
    # alert: Unused, useful for front-end debugging
    # new_score: only set if rating_change == true, contains the updated score for the review
    if last_rating.nil? || last_rating == NEGATIVE_STRING

      new_score = if last_rating.nil?
                    # If no existing rating exists in this session, proceed as normal
                    @review.score + 1
                  else
                    # If an existing negative rating exists, reverse that rating and save it
                    # a +ve rating counts as +1 score while a negative rating is -1, so undoing a
                    # -ve rating and applying a +ve one gives +2
                    @review.score + 2
                  end
      @review.update(score: new_score)
      # Set session variable for future reviews
      session['review_ratings'][@review.id.to_s] = POSITIVE_STRING
      # Return JSON so AJAX frontend can behave as expected
      render json: { old_rating: !last_rating.nil?, rating_change: true, alert: 'Feedback submitted successfully',
                     new_score: new_score }
    elsif last_rating == POSITIVE_STRING
      # If an existing positive rating exists in the session, return JSON without changing anything
      render json: { old_rating: true, rating_change: false,
                     alert: 'You have already submitted a rating for this review' }
    end
  end

  # Decrease the score for a given review based on a user rating
  # POST: /reviews/:id/decrease_score
  def decrease_score
    # Check the current session for an existing rating as we don't want users to need to sign in to rate reviews
    last_rating = nil

    if !session['review_ratings'].nil?
      last_rating = session['review_ratings'][@review.id.to_s]
    else
      session['review_ratings'] = {}
    end

    # Respond appropriately to the situation
    # JSON response fields:
    # old_rating: Was there a rating in the session for this review?
    # rating_change: as a result of the action did the rating for this review change
    # alert: Unused, useful for front-end debugging
    # new_score: only set if rating_change == true, contains the updated score for the review
    if last_rating.nil? || last_rating == POSITIVE_STRING
      new_score = if last_rating.nil?
                    # If no existing rating exists in this session, proceed as normal
                    @review.score - 1
                  else
                    # If an existing positive rating exists, reverse that rating and save it
                    # a -ve rating counts as -1 score while a +ve rating is +1, so undoing a +ve rating and applying a
                    # -ve one gives -2
                    @review.score - 2
                  end

      @review.update(score: new_score)
      # Set session variable for future ratings for this review
      session['review_ratings'][@review.id.to_s] = NEGATIVE_STRING
      # Return JSON so AJAX frontend can behave as expected
      render json: { old_rating: !last_rating.nil?, rating_change: true, alert: 'Feedback submitted successfully',
                     new_score: new_score }
    elsif last_rating == NEGATIVE_STRING
      # If an existing negative rating exists in the session, return JSON without changing anything
      render json: { old_rating: true, rating_change: false,
                     alert: 'You have already submitted a rating for this review' }
    end
  end

  # Update a review to be moved into the pinned section on the page
  # POST: /reviews/:id/pin_review
  def pin_review
    @review.update_attribute(:pinned, !@review.pinned)
    render json: { success: true }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def review_params
    params.require(:review).permit(:first_name, :last_name, :anonymous, :review)
  end

  # Sets the number of reviews that will be visible in the general review table for the user
  # (for pagination purposes)
  def set_review_count
    @review_count = if user_signed_in?
                      Review.where({ pinned: false }).count
                    else
                      Review.where({ pinned: false, hidden: false }).count
                    end
  end

  # Sets the total number of pages that are needed to display all the reviews
  def set_total_pages
    # The float conversion here is neccessary to avoid integer division which gives an incorrect page count
    @total_pages = (@review_count.to_f / REVIEWS_PER_PAGE).ceil
  end

  # Set the current method of ordering of reviews from the URL query string
  def set_current_ordering
    @current_ordering = Ordering::DATE_DESC

    begin
      @current_ordering = Integer(params[:ordering]) unless params[:ordering].nil?
      # Check the desired ordering exists, if it doesn't redirect to error
      redirect_to '/422' unless Ordering.check_in_range(@current_ordering)
    rescue ArgumentError
      # Argument error thrown when params[:ordering] isn't an integer
      Rails.logger.warn 'ORDERING: caught error: ' + params[:ordering]
      redirect_to '/422'
    end
  end


  # Set the current page of reviews the user is on from the URL query string
  def set_current_page
    @current_page = 1
    begin
      unless params[:page_no].nil?
        @current_page = Integer(params[:page_no])

        # Default out of range values to their nearest in range value
        if @current_page > @total_pages
          @current_page =  @total_pages
        elsif @current_page < 1
          @current_page = 1
        end
      end
    rescue ArgumentError
      # Argument error thrown when params[:page_no] isn't an integer
      Rails.logger.warn 'PAGE-NUMBER: caught error: ' + params[:page_no]
      redirect_to '/422'
    end
  end

  # Returns a list of reviews depending on the ordering and page number given
  def get_reviews_for_ordering_and_page(ordering, page_no)
    # If the user is not signed in, return all the reviews that aren't either pinned or hidden (otherwise it will
    # break the pagination)

    if ordering == Ordering::DATE_DESC
      reviews = Review.accessible_by(current_ability).where({ pinned: false }).order(created_at: :desc).limit(REVIEWS_PER_PAGE)
                      .offset((page_no - 1) * REVIEWS_PER_PAGE)
    elsif ordering == Ordering::DATE_ASC
      reviews = Review.accessible_by(current_ability).where({ pinned: false }).order(created_at: :asc).limit(REVIEWS_PER_PAGE)
                      .offset((page_no - 1) * REVIEWS_PER_PAGE)
    elsif ordering == Ordering::SCORE_DESC
      reviews = Review.accessible_by(current_ability).where({ pinned: false }).order(score: :desc).limit(REVIEWS_PER_PAGE)
                      .offset((page_no - 1) * REVIEWS_PER_PAGE)
    end
    reviews
  end

  # Checks for empty inputs to the create method
  def validate_inputs(review_params)
    first_name = review_params[:first_name].empty? ? nil : review_params[:first_name]
    last_name = review_params[:last_name].empty? ? nil : review_params[:last_name]
    review = review_params[:review].empty? ? nil : review_params[:review]

    [first_name, last_name, review]
  end
end
