extends Control

@export var speed_input_box: LineEdit
@export var bpm_input_box: LineEdit
@export var subdivisions_input_box: LineEdit

@export var horizontal_divisions_input_box: LineEdit
@export var vertical_divisions_input_box: LineEdit

func _ready():
	speed_input_box.text_submitted.connect(on_float_input_box_updated)
	bpm_input_box.text_submitted.connect(on_float_input_box_updated)
	
	subdivisions_input_box.text_submitted.connect(on_int_input_box_updated)
	horizontal_divisions_input_box.text_submitted.connect(on_int_input_box_updated)
	vertical_divisions_input_box.text_submitted.connect(on_int_input_box_updated)
	update()

func update():
	speed_input_box.text = str(GlobalManager.scroll_speed)
	bpm_input_box.text = str(GlobalManager.bpm)
	subdivisions_input_box.text = str(GlobalManager.subdivisions)
	horizontal_divisions_input_box.text = str(GlobalManager.horizontal_divisions)
	vertical_divisions_input_box.text = str(GlobalManager.vertical_divisions)

func on_float_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_float():
		# Usually, info boxes don't set stuffs directly like this, but this is a special case! 
		GlobalManager.scroll_speed = float(speed_input_box.text)
		GlobalManager.bpm = float(bpm_input_box.text)
		SignalManager.on_grid_drawer_needs_update.emit()
	else:
		update()

func on_int_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_int():
		# Usually, info boxes don't set stuffs directly like this, but this is a special case! 
		GlobalManager.subdivisions = int(subdivisions_input_box.text)
		GlobalManager.horizontal_divisions = int(horizontal_divisions_input_box.text)
		GlobalManager.vertical_divisions = int(vertical_divisions_input_box.text)
		SignalManager.on_grid_drawer_needs_update.emit()
	else:
		update()
