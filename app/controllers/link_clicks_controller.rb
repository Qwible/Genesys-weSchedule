# frozen_string_literal: true

class LinkClicksController < ApplicationController
  def create
    permitted_params = params.permit(:link_name, :link_css_id, :url)
    current_visit.link_clicks.create(permitted_params)
    head 200 # replacement for 'render nothing: true'
  end
end
