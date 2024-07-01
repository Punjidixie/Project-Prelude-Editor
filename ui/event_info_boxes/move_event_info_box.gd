extends EventInfoBox

class_name MoveEventInfoBox

@export var time_input_box: LineEdit
@export var start_dropdown: OptionButton
@export var destination_dropdown: OptionButton
@export var button: Button
@export var delete_button: Button

# Personal connections
func _ready():
	time_input_box.text_submitted.connect(on_time_input_box_updated)
	
	start_dropdown.button_down.connect(populate_start_dropdown)
	destination_dropdown.button_down.connect(populate_destination_dropdown)
	
	start_dropdown.item_selected.connect(on_start_dropdown_selected)
	destination_dropdown.item_selected.connect(on_destination_dropdown_selected)
	button.toggled.connect(on_button_toggled)
	delete_button.pressed.connect(on_delete_button_pressed)

func update():
	super.update()
	var move_event := event as MoveEvent
	time_input_box.text = str(move_event.start_time)
	populate_start_dropdown()
	populate_destination_dropdown()

func on_time_input_box_updated(new_string: String):
	if new_string.is_valid_float():
		load_info_to_event()
		SignalManager.on_event_info_boxes_need_reordering.emit()
	else:
		update() # Reset text box

func populate_dropdown(target: NoteCheckpoint, dropdown: OptionButton):
	dropdown.clear()
	var target_index = 0
	dropdown.add_item("None")

	var checkpoints: Array = event.note.get_note_checkpoints()
	for i in range(checkpoints.size()):
		var checkpoint: NoteCheckpoint = checkpoints[i]
		dropdown.add_item(checkpoint.checkpoint_name)
		if checkpoint == target: target_index = i + 1
	
	dropdown.select(target_index)

func populate_start_dropdown():
	var move_event := event as MoveEvent
	populate_dropdown(move_event.start_checkpoint, start_dropdown)

func populate_destination_dropdown():
	var move_event := event as MoveEvent
	populate_dropdown(move_event.destination_checkpoint, destination_dropdown)
	
func on_start_dropdown_selected(index: int):
	var move_event := event as MoveEvent
	if index == 0: move_event.remove_start_checkpoint()
	else: 
		var checkpoints: Array = event.note.get_note_checkpoints()
		move_event.change_start_checkpoint(checkpoints[index - 1])

func on_destination_dropdown_selected(index: int):
	var move_event := event as MoveEvent
	if index == 0: move_event.remove_destination_checkpoint()
	else: 
		var checkpoints: Array = event.note.get_note_checkpoints()
		move_event.change_destination_checkpoint(checkpoints[index - 1])

func on_button_toggled(_toggle_on: bool):
	var move_event := event as MoveEvent
	move_event.spawn_path_points()
	# Despawn all path points on other move events + initialize curve editor
	SignalManager.on_move_event_selected.emit(move_event)

func on_delete_button_pressed():
	var move_event := event as MoveEvent
	move_event.delete()
	queue_free()

