extends Node

class_name CheckpointInfoBox

@export var checkpoint_name_label: Label
@export var time_input_box: LineEdit
@export var x_input_box: LineEdit
@export var y_input_box: LineEdit

var checkpoint : NoteCheckpoint

func _ready():
	time_input_box.text_submitted.connect(on_float_input_box_updated)
	x_input_box.text_submitted.connect(on_float_input_box_updated)
	y_input_box.text_submitted.connect(on_float_input_box_updated)
	
func initialize(_checkpoint : NoteCheckpoint):
	checkpoint = _checkpoint
	checkpoint.on_checkpoint_ui_needs_update.connect(update)
	checkpoint.on_checkpoint_renamed.connect(rename)
	update()

func update():
	checkpoint_name_label.text = checkpoint.checkpoint_name
	time_input_box.text = str(checkpoint.target_time)
	x_input_box.text = str(checkpoint.play_position.x)
	y_input_box.text = str(checkpoint.play_position.y)

func load_info_to_checkpoint() -> void:
	checkpoint.load_info_from_info_box(self)

func rename():
	checkpoint_name_label.text = checkpoint.checkpoint_name

func on_float_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_float():
		load_info_to_checkpoint()
	else:
		update()
	
