extends EventInfoBox

class_name EndEventInfoBox

@export var time_label: Label
@export var end_speed_input_box: LineEdit

func _ready():
	end_speed_input_box.text_submitted.connect(on_input_box_updated)
	
func update():
	super.update()
	var end_event := event as EndEvent
	time_label.text = str(end_event.start_time)
	end_speed_input_box.text = str(end_event.end_speed)
	SignalManager.on_event_info_boxes_need_reordering.emit()

func on_input_box_updated(new_string: String):
	if new_string.is_valid_float():
		load_info_to_event()
	else:
		update() # Reset text box
