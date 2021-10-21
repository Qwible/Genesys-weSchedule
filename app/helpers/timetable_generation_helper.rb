module TimetableGenerationHelper
  # Returns all events that meet at least one of three conditions:
  #  1 - The event starts after the current event is due to start and before the end of the current specified workday
  #  2 - The event ends after the current event is due to start, but on the same day
  #  3 - The event starts before the current event is due to start and ends after the current event is due to end
  #
  # The goal is to get a list of user created calendar events that could be in the way of allocating a task on the
  # day that it is being attempted to be scheduled
  #
  # Params:
  #   existing_events: A list of existing  user created (i.e. not auto generated) events
  #   current_start: A date time value of when the start of the current event will be attempted to be allocated
  #   current_end: A date time value of when the end of the current event will be attempted to be allocated
  #   user_prefs: A UserPreferences object containing all of the users preferences (such as start and end of the
  #               workday)
  def self.get_active_events(existing_events, current_start, current_end, user_prefs)
    active_events = existing_events.select{|evt| (evt.event_start >= current_start &&
                                                evt.event_start <= current_start.midnight + user_prefs.workday_end) ||
                                                (evt.event_end > current_start &&
                                                evt.event_end <= current_start.midnight + 1.day) ||
                                                (evt.event_start <= current_start && evt.event_end >= current_end)}
    return active_events
  end
  # A helper method to calculate the start and end times for which a calendar event can be scheduled
  # (i.e. moves the start and end date to not conflict with existing tasks)
  #
  # Params:
  #   active_events: A list of events that are deemed active (simply could get in the way of task
  #                   allocation, see get_active_events for more details)
  #   current_start: A date time value of when the start of the current event will be attempted to be allocated
  #   current_end: A date time value of when the end of the current event will be attempted to be allocated
  #   user_prefs: A UserPreferences object containing all of the users preferences (such as start and end of the
  #               workday)
  # Returns:
  #   An array with tree indexes, [0] = The updated value of current_start, [1] = The updated value of current_end
  #   and [2] = whether the loop needs to be repeated to update the active events
  def self.get_start_times_from_active_events(active_events, current_start, current_end, user_prefs)
    if(active_events.length() == 1)
      return get_start_and_end_one_active(active_events[0], current_start, current_end, user_prefs)
    elsif(active_events.length() > 1)
      return get_start_and_end_multiple_active(active_events, current_start, current_end, user_prefs)
    end
  end

  # A method to help dictate when a task can be automatically scheduled for allocation when it has
  # one active task (see get_active_tasks) to avoid.
  #
  # params:
  #   active_event: A CalendarEvent object that the event needs to be allocated around
  #   current_start: A date time value of when the start of the current event will be attempted to be allocated
  #   current_end: A date time value of when the end of the current event will be attempted to be allocated
  #   user_prefs: A UserPreferences object containing all of the users preferences (such as start and end of the
  #               workday)
  # Returns:
  #   An array with tree indexes, [0] = The updated value of current_start, [1] = The updated value of current_end
  #   and [2] = whether the loop needs to be repeated to update the active events
  def self.get_start_and_end_one_active(active_event, current_start, current_end, user_prefs)
    #Init variables
    new_start = current_start
    new_end = current_end
    need_redo = false

    # Check the event starts before the end of the workday and ends after the start of the workday
    if(active_event.event_end >= current_start.midnight + user_prefs.workday_start.seconds &&
       active_event.event_start <= current_start.midnight + user_prefs.workday_end.seconds)

      # If the active event ends after the current event starts and starts before the current event starts
      if(active_event.event_end >= current_start && active_event.event_start <= current_start)
        # If the active event ends before the end of the workday
        if(active_event.event_end < current_start.midnight + user_prefs.workday_end.seconds)
          # Start the event at the end of the active one and end at the end of the day
          new_start = active_event.event_end
          new_end = current_start.midnight + user_prefs.workday_end.seconds
        else
          # Attempt to schedule the current event for the next day and signal that the outer loop needs to
          # be restarted
          new_start = current_start.midnight + 1.day + user_prefs.workday_start.seconds
          new_end = current_start.midnight + 1.day + user_prefs.workday_end.seconds
          need_redo = true
        end
      # Else if the active event starts after the current event should start
      elsif(active_event.event_start > current_start)
        # End the current event when the active one starts
        new_end = active_event.event_start
      end
    else
      # If the active event starts after the end of the workday or ends before the start of the workday
      if(active_event.event_start >= current_start.midnight + user_prefs.workday_end.seconds ||
        active_event.event_end <= current_start.midnight + user_prefs.workday_start.seconds)
        # It can safely be ignored and the current event can be scheduled as intended
        new_start = current_start
        new_end = current_end
        need_redo = false
      # If the event starts before the current workday and ends after the work day ends
      else
        # Increment the start and end dates by a day and try again
        new_start = current_start.midnight + 1.day + user_prefs.workday_start.seconds
        new_end = current_start.midnight + 1.day + user_prefs.workday_end.seconds
        need_redo = true
      end
    end

    return [new_start, new_end, need_redo]
  end

  # A method to help dictate when a task can be automatically scheduled for allocation when it has
  # multiple active tasks (see get_active_tasks) to avoid.
  #
  # params:
  #   active_events: A list of CalendarEvent objects that the event needs to be allocated around, sorted by start time
  #   current_start: A date time value of when the start of the current event will be attempted to be allocated
  #   current_end: A date time value of when the end of the current event will be attempted to be allocated
  #   user_prefs: A UserPreferences object containing all of the users preferences (such as start and end of the
  #               workday)
  # Returns:
  #   An array with tree indexes, [0] = The updated value of current_start, [1] = The updated value of current_end
  #   and [2] = whether the loop needs to be repeated to update the active events
  def self.get_start_and_end_multiple_active(active_events, current_start, current_end, user_prefs)
    new_start = current_start
    new_end = current_end
    need_redo = false

    # If the first event is due to start after the current event would
    if(active_events[0].event_start <= current_start)
      # If the first active event before or when the second one starts
      if(active_events[0].event_end <= active_events[1].event_start)
        # Update the current start  to remove the first event from the
        # active list and redo the loop, to allow the current event to
        # be planned around any other events
        new_start = active_events[0].event_end
        need_redo = true
      # Else if the first active event ends after the second active event starts
      elsif(active_events[0].event_end > active_events[1].event_start)
        # Update the current start to the end of the second event and restart the loop
        # This removes both active events, so that the event can be planned around any following
        # events
        new_start = active_events[1].event_end
        need_redo = true
      end
    # Else the first event starts after the current one
    else
      # So we can just end the current event when the first one starts
      new_end = active_events[0].event_start
    end

    return [new_start, new_end, need_redo]
  end

  # A helper method to get the ammount of time in hours that has allocated by a list of calendar events
  #
  # Params:
  #   task_events: A list of calendar events to have their length summed up
  #
  # Returns:
  #   The ammount of time in hours that has been allocated by the input events
  def self.get_task_pre_allocated_time(task_events)
    pre_alloc_time = 0
    task_events.each do |evt|
      pre_alloc_time += (evt.event_end.to_i - evt.event_start.to_i) / (60.0 * 60.0)
    end
    return pre_alloc_time
  end

  # A helper method to clear all automatically generated events for a given user from the calendar so a new timetable can
  # be generated
  #
  # Params:
  #   user_id: The id of the user who's calendar events should be cleared
  def self.clear_all_future_generated_tasks(user_id)
    all_tasks = Task.where(user_id: user_id)
    all_tasks.each do |t|
      CalendarEvent.where("task_id = ? AND auto_generated = ? AND event_end > ?", t.id, true, Time.now).destroy_all
    end
  end

  # A helper method to get all the calendar events created by a given user
  #
  # Params:
  #   user_id: The id of the user who's events should be returned.
  def self.get_all_existing_events(user_id)
    all_tasks = Task.where(user_id: user_id)
    task_ids = all_tasks.map{|t| t.id}
    existing_events = CalendarEvent.where(task_id:  task_ids).order(:event_start)
    return existing_events
  end
end
