# frozen_string_literal: true

class ShareMetricsController < ApplicationController
  before_action :authenticate_user!

  def index
    @visits = Visit.includes(:link_clicks).order('created_at DESC').uniq
    @registrations = Registration.all
    @links = LinkClick.where(link_css_id: %w[f1-share-twitter f2-share-twitter
                                             f3-share-twitter f4-share-twitter
                                             f5-share-twitter f1-share-email
                                             f2-share-email f3-share-email
                                             f4-share-email f5-share-email])
  end
end
