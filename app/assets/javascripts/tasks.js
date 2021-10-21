$(() => {
  // initialize each item in task backlog with necessary jquery
  $("#external-events .fc-event").each(function (index) {
    // store data so the calendar knows to render an event upon drop
    $(this).data("event", {
      title: tasks[index].name,
      stick: true, // maintain when user navigates (see docs on the renderEvent method)
      task: tasks[index], //Have to store task in jquery element to access it after dropped on calendar
    });

    // make the event draggable using jQuery UI
    $(this).draggable({
      zIndex: 999,
      revert: true, // will cause the event to go back to its
      revertDuration: 0, //  original position after the drag
    });
    $(this).click(function () {
      window.location = window.origin + "/tasks/" + tasks[index].id + "/edit";
    });
    //Change colour if manually scheduled
    if (!tasks[index].schedule) $(this).css("background-color", "slategray");
  });
  $("#calendar").fullCalendar({
    events: convertTasksToEvents(calendarEvents),
    defaultView: "agendaWeek",
    nowIndicator: true,
    header: {
      left: "prev,next today",
      center: "title",
      right: "month,agendaWeek,agendaDay",
    },
    editable: true,
    droppable: true,
    eventDrop: moveCalendarEventWithinCalendar,
    eventResize: moveCalendarEventWithinCalendar,
    //? Might be better off taking them to edit page? One for patrick to decide maybe
    eventClick: (event) => {
      window.location = `/tasks/${event.task_id}/edit`;
    },
    //After calendar received element from backlog, update task to have new start/end time
    eventReceive: moveEventToCalendarFromBacklog,
    //After dragging a calendar event
    eventDragStop: function (event, jsEvent) {
      //If after dragging, event in is backlog, remove it from calendar
      if (isEventInExternalEventsDiv(jsEvent.pageX, jsEvent.pageY)) {
        moveEventToBacklogFromCalendar(event);
      }
    },
  });
});

/**
 * Called on event dragged within calendar or resized
 * Extracts task from calendar event and sends PUT request to backend
 */
function moveCalendarEventWithinCalendar(event) {
  const calendarEvent = {
    task_id: event.task_id,
    event_start: event.start.toDate(),
    event_end: event.end.toDate(),
    auto_generated: false,
    late_alert: false,
  };
  $.ajax({
    type: "PUT",
    url: "/tasks/" + event.task_id + "/calendar_events/" + event.event_id,
    processData: true,
    data: {
      calendar_event: calendarEvent,
    },
  });
}

/**
 * Called when event added to calendar from backend
 * Extract start/end from calendar from calendar and update task in backend
 * (note does not handle actually adding event to calendar, as this is done by full-calendar)
 */
const moveEventToCalendarFromBacklog = (event) => {
  let task = event.task;
  let evt_start = event.start;
  let evt_end = moment(evt_start).add(2, "hours");
  const calendarEvent = {
    task_id: task.id,
    event_start: evt_start.toDate(),
    //Full calendar is dumb and doesn't always supply an end time
    event_end: evt_end.toDate(),
    auto_generated: false,
    late_alert: false,
  };
  $.ajax({
    type: "POST",
    url: "/tasks/" + task.id + "/calendar_events",
    processData: true,
    data: {
      calendar_event: calendarEvent,
    },
    success: (response) => {
      event.event_id = response.id;
      event.task_id = task.id;
      event.start = evt_start;
      event.end = evt_end;

      event.backgroundColor = "SlateGray";
      event.textColor = "GhostWhite";
      event.borderColor = "Black";

      $("#calendar").fullCalendar("updateEvent", event);
    },
  });
};

/**
 * Move event from calendar back to task backlog
 */
const moveEventToBacklogFromCalendar = (event) => {
  //Remove event from calendar
  console.log("Event: ", event);
  $("#calendar").fullCalendar("removeEvents", event._id);
  $.ajax({
    type: "DELETE",
    url: "/tasks/" + event.task_id + "/calendar_events/" + event.event_id,
  });
};

/**
 * Check if coordinates are within the #external-events div
 * @returns true|false
 */
const isEventInExternalEventsDiv = function (x, y) {
  const external_events = $("#external-events");
  let offset = external_events.offset();
  offset.right = external_events.width() + offset.left;
  offset.bottom = external_events.height() + offset.top;

  return (
    x >= offset.left - 10 &&
    y >= offset.top - 10 &&
    x <= offset.right + 10 &&
    y <= offset.bottom + 10
  );
};

$(document).ready(() => {
  $("#generate-timetable-link").click(() => {
    $.ajax({
      method: "POST",
      url: "/tasks/generate_time_table",
      success: async () => {
        // It doesn't always load the changes unless you wait for a bit, possibly down
        // to rails returning the request before the database changes have been comitted
        await new Promise(r => setTimeout(r, 1000))
        location.reload();
      },
    });
  });
});

/**
 *  Simple function to rename the tasks to play nice with the fullCalendar
 *  @param tasks, Array of tasks in json format from backend
 *  @returns tasks, formatted tasks that play nice with calendar
 *
 */
const convertTasksToEvents = (calendarEvents) => {
  const events = calendarEvents.map((calendarEvent) => {
    const event = {
      title: calendarEvent.name,
      allDay: false,
      // Convert event starts from CalendarEvent objects into the form FullCalendar wants
      start: calendarEvent.event_start,
      end: calendarEvent.event_end,
      // Change the event background color if it is scheduled late
      backgroundColor: getEventBackgroundColour(calendarEvent),
      textColor: getEventTextColour(calendarEvent),
      borderColor: "Black",
      event_id: calendarEvent.calendar_event_id,
      task_id: calendarEvent.id,
    };
    return event;
  });
  return events;
};

function getEventBackgroundColour(event) {
  if (event.auto_generated === false) {
    return "SlateGray";
  } else if (event.late_alert === false) {
    return "LightSkyBlue";
  } else {
    return "Tomato";
  }
}

function getEventTextColour(event) {
  if (event.auto_generated === false) {
    return "GhostWhite";
  } else {
    return "Black";
  }
}
