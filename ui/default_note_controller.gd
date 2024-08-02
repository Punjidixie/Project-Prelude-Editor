extends Node


@export var size_input_box: LineEdit
@export var speed_input_box: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	size_input_box.text_submitted.connect(on_float_input_box_updated)
	speed_input_box.text_submitted.connect(on_float_input_box_updated)
	update()

func _process(delta):
	if Input.is_action_just_pressed("sync_note_parameters"):
		if is_instance_valid(GlobalManager.selected_note):
			GlobalManager.selected_note.load_default_note_parameters()
	
func update():
	size_input_box.text = str(GlobalManager.default_note_size)
	speed_input_box.text = str(GlobalManager.default_note_speed)
	
func on_float_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_float():
		GlobalManager.default_note_size = float(size_input_box.text)
		GlobalManager.default_note_speed = float(speed_input_box.text)
	else:
		update()
	
	size_input_box.release_focus()
	speed_input_box.release_focus()
	
