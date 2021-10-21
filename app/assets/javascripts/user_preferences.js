$(document).ready(() => {
  let start_input = $('#user_preference_workday_start');
  let end_input = $('#user_preference_workday_end');
  start_input.on("change", function(){
    let is_valid = validate_time_inputs(start_input.val(), end_input.val());
    if(!is_valid){
      end_input.val(start_input.val())
    }
  })

  end_input.on("change", function(){
    let is_valid = validate_time_inputs(start_input.val(), end_input.val());
    if(!is_valid){
      end_input.val(start_input.val())
    }
  })
})

// Function to validate two time inputs to ensure that the time on the input labelled 'end' is not before
// the input labelled 'start'
function validate_time_inputs(start, end){
  let start_split = start.split(':');
  let end_split = end.split(':');

  if(parseInt(start_split[0]) < parseInt(end_split[0])){
    return true;
  } else if(parseInt(start_split[0]) === parseInt(end_split[0])) {
    if(parseInt(start_split[1]) <= parseInt(end_split[1])){
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}