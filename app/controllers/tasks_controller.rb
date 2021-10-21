class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :allowed_users_only

  # GET /tasks
  def index
    @tasks = Task.where(user_id: current_user.id)
    @events = Task.joins(:calendar_events)
                  .select('tasks.name as name, tasks.id as id, '\
                          'calendar_events.event_start as event_start, '\
                          'calendar_events.event_end as event_end, '\
                          'calendar_events.late_alert as late_alert, '\
                          'calendar_events.id as calendar_event_id, '\
                          'calendar_events.auto_generated as auto_generated')
                  .where(user_id: current_user.id)

    # Set an alert if an event needed to be scheduled after its event end
    @alert = false
    @late_events = @events.where(calendar_events:{late_alert: true})
    if @late_events.any?
      @alert = true
    end
  end

  # GET /tasks/1
  def show
    @user = current_user
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @user = current_user
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    @task.priority = @task.priority || 1
    @task.length = @task.length || 1

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    @task.update(task_params)
    redirect_to tasks_url, notice: 'Task was successfully updated.'
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  def generate_time_table
    # Get backlog for user
    user = current_user
    user_prefs =  UserPreference.find_by(user_id: current_user.id)
    tasks = Task.where(user_id: current_user.id, schedule:true).order(priority: :asc, end_datetime: :asc)

    # Clear any existing events from the database
    TimetableGenerationHelper.clear_all_future_generated_tasks(current_user.id)

    current_start = 1.day.from_now.midnight + user_prefs.workday_start.seconds
    event_end = 1.day.from_now.midnight + user_prefs.workday_end.seconds

    # Get all manually added tasks
    existing_events = TimetableGenerationHelper.get_all_existing_events(current_user.id)
    tasks.each do |t|
      # See if some of the task has been allocated manually and subtract those from the time
      # needed to allocate
      task_events = existing_events.select{|e| e.task_id == t.id}
      time_left = t.length - TimetableGenerationHelper.get_task_pre_allocated_time(task_events)

      # Reset the expected end of the event for the next task and instanciate it for the
      # first task
      event_end = current_start.midnight + user_prefs.workday_end.seconds
      # Keep creating calendar events for the task until there is no more time to be allocated

      while time_left > 0 do

        # If the user does not want to work on weekends skip to next weekday
        if(user_prefs.weekends == false)
          if(current_start.saturday?)
            current_start += 2.days
            event_end += 2.days
          elsif (current_start.sunday?)
            current_start += 1.day
            event_end += 1.days
          end
        end

        # Get all manually allocated events that could interfere with the current allocation
        active_events = TimetableGenerationHelper.get_active_events(existing_events, current_start, event_end, user_prefs)
        # If there are events that need to be avoided call the helper method to get the new start and end times and if the loop
        # needs to be redone with these new dates in mind
        if(active_events.length() > 0)
          evt_time_status = TimetableGenerationHelper.get_start_times_from_active_events(active_events, current_start, event_end, user_prefs)
          current_start = evt_time_status[0]
          event_end = evt_time_status[1]
          redo if evt_time_status[2] == true
        end

        #Start creating the event to go on the calendar
        evt = CalendarEvent.new
        evt.event_start = current_start
        evt.task_id = t.id
        evt.auto_generated = true

        # Get how much time (in hours) has passed from the duration of the event
        event_time = (event_end.to_i - current_start.to_i)/(60.0*60.0)
        if(event_time > 0)
          # If that time is more than is necessary subtract the excess from the event end to get
          # the correct end time
          if (time_left - event_time) < 0
            event_end -= (event_time - time_left).hours
            time_left = 0 # Set time left to zero to break the loop
          # Else just subtract the time taken from this event to continue on allocating
          else
            time_left -= event_time
          end
        end
        evt.event_end = event_end
        # Set an alert if the calendar event is scheduled for after the task ends
        evt.late_alert = event_end.to_i > t.end_datetime.to_i

        # If the event is due to take 0 or less time, ignore it
        # otherwise save to the database
        if(event_time >= 0)
          evt.save
        end

        # If the event has ended at the user defined end of workday
        if(event_end == event_end.midnight + user_prefs.workday_end)
          # Set early start and end times for the next day (to be used by the next iteration)
          current_start = (current_start + 1.day).midnight + user_prefs.workday_start.seconds
          event_end = (event_end + 1.day).midnight + user_prefs.workday_end.seconds
        # Otherwise the event has ended in the middle of the day
        else
          # Set up the next event to take up the rest of the workday (which will only happen if the time is
          # available)
          current_start = event_end
          event_end = event_end.midnight + user_prefs.workday_end.seconds
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def task_params
      params.require(:task).permit(:name, :start_datetime, :end_datetime, :length, :priority, :schedule)
    end

    def allowed_users_only
      unless can? :manual_calendar, current_user
        redirect_to '/', :alert => "Access denied."
      end
    end
end
