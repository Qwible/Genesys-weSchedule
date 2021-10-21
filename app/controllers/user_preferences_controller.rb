class UserPreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :allowed_users_only

  def index
    @user_preference = UserPreference.find_by(user_id: current_user.id)
    
    u_events = Task.joins(:calendar_events)
                .select('tasks.name as name, tasks.id as id, '\
                        'calendar_events.event_start as event_start, '\
                        'calendar_events.event_end as event_end, '\
                        'calendar_events.late_alert as late_alert, '\
                        'calendar_events.id as calendar_event_id, '\
                        'calendar_events.auto_generated as auto_generated')
                .where('tasks.user_id = ? AND calendar_events.event_start >= ? AND calendar_events.event_end <= ?', current_user.id, 7.days.ago, Time.now)
    @hours_studied = TimetableGenerationHelper.get_task_pre_allocated_time(u_events)
  end

  def update
    @user_preference = UserPreference.find_by(user_id: current_user.id)
    @user_preference.workday_start = UserPreferencesHelper.convert_time_string_to_int(preference_params[:workday_start])
    @user_preference.workday_end = UserPreferencesHelper.convert_time_string_to_int(preference_params[:workday_end])
    @user_preference.weekends = preference_params[:weekends]

    @user_preference.save
    redirect_to '/user_preferences', notice: 'Preferences Updated'
  end

  private

    def preference_params
      params.require(:user_preference).permit(:workday_start, :workday_end, :alternate_tasks, :weekends)
    end

    def allowed_users_only
      unless can? :manage, UserPreference
        redirect_to '/', :alert => "Access denied, must be a premium user to access timetable generation settings"
      end
    end
end
