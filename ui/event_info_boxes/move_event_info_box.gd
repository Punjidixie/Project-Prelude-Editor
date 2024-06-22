extends EventInfoBox

class_name MoveEventInfoBox

@export var time_input_box: LineEdit
@export var start_dropdown: OptionButton
@export var destination_dropdown: OptionButton

# Personal connections
func _ready():
	time_input_box.text_submitted.connect(on_time_input_box_updated)

func update():
	super.update()
	var move_event := event as MoveEvent
	time_input_box.text = str(move_event.start_time)
	populate_dropdowns()

func on_time_input_box_updated(new_string: String):
	if new_string.is_valid_float():
		load_info_to_checkpoint()
	else:
		update() # Reset text box

func populate_dropdowns():
	start_dropdown.clear()
	destination_dropdown.clear()
	var checkpoints: Array = event.note.get_note_checkpoints()
	for i in range(checkpoints.size()):
		var checkpoint: NoteCheckpoint = checkpoints[i]
		start_dropdown.add_item(checkpoint.checkpoint_name)
		destination_dropdown.add_item(checkpoint.checkpoint_name)

func on_edit_curve_button_pressed():
	var move_event := event as MoveEvent
	# move_event.show_path_points
