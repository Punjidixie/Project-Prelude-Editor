extends EventInfoBox

class_name MoveEventInfoBox

@export var time_input_box: LineEdit

# Personal connections
func _ready():
	time_input_box.text_submitted.connect(on_time_input_box_updated)

func update():
	var move_event := event as MoveEvent
	event_name_label.text = event.name
	time_input_box.text = str(move_event.start_time)

func on_time_input_box_updated(new_string: String):
	if new_string.is_valid_float():
		load_info_to_checkpoint()
	else:
		update() # Reset text box

func on_edit_curve_button_pressed():
	var move_event := event as MoveEvent
	# move_event.show_path_points
