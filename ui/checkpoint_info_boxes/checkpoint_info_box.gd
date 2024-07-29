extends Node

class_name CheckpointInfoBox

@export var checkpoint_name_label: Label
@export var time_input_box: LineEdit
@export var x_input_box: LineEdit
@export var y_input_box: LineEdit
@export var delete_button: Button

var checkpoint : NoteCheckpoint

func _ready():
	time_input_box.text_submitted.connect(on_float_input_box_updated)
	x_input_box.text_submitted.connect(on_float_input_box_updated)
	y_input_box.text_submitted.connect(on_float_input_box_updated)
	delete_button.pressed.connect(on_delete_button_pressed)
	
func initialize(_checkpoint : NoteCheckpoint):
	checkpoint = _checkpoint
	checkpoint.on_checkpoint_ui_needs_update.connect(update)
	checkpoint.on_checkpoint_renamed.connect(rename)
	if checkpoint.checkpoint_type in [checkpoint.CheckpointType.START, checkpoint.CheckpointType.END]:
		delete_button.hide()
	update()

func update():
	checkpoint_name_label.text = checkpoint.checkpoint_name
	
	if time_input_box.text != str(checkpoint.target_time):
		time_input_box.text = str(checkpoint.target_time)
		SignalManager.on_checkpoint_info_boxes_need_reordering.emit()

	x_input_box.text = str(checkpoint.play_position.x)
	y_input_box.text = str(checkpoint.play_position.y)
	

func load_info_to_checkpoint() -> void:
	checkpoint.load_info_from_info_box(self)

func rename():
	checkpoint_name_label.text = checkpoint.checkpoint_name

func on_float_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_float():
		load_info_to_checkpoint()
		SignalManager.on_checkpoint_info_boxes_need_reordering.emit()
	else:
		update()

func on_delete_button_pressed():
	checkpoint.delete()
	queue_free()
	
