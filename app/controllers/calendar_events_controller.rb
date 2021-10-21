class CalendarEventsController < ApplicationController
  before_action :set_calendar_event, only: [:update, :destroy]
  before_action :authenticate_user!

  def create
    @calendar_event = CalendarEvent.create(calendar_event_params)
    render :json => {id: @calendar_event.id}
  end

  def update
    @calendar_event.update(calendar_event_params)
  end

  def destroy
    @calendar_event.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_event
      @calendar_event = CalendarEvent.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def calendar_event_params
      params.require(:calendar_event).permit(:task_id, :event_end, :event_start, :auto_generated, :late_alert)
    end
end
