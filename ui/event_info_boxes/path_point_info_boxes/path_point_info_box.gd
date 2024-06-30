extends Control

class_name PathPointInfoBox

var path_point: PathPoint
@export var x_input_box: LineEdit
@export var y_input_box: LineEdit
@export var x_control_input_box: LineEdit
@export var y_control_input_box: LineEdit
@export var remove_button: Button

func _ready():
	x_input_box.text_submitted.connect(on_float_input_box_updated)
	y_input_box.text_submitted.connect(on_float_input_box_updated)
	x_control_input_box.text_submitted.connect(on_float_input_box_updated)
	y_control_input_box.text_submitted.connect(on_float_input_box_updated)
	remove_button.pressed.connect(on_remove_button_pressed)

func update():
	x_input_box.text = str(path_point.play_position.x)
	y_input_box.text = str(path_point.play_position.y)
	x_control_input_box.text = str(path_point.out_point.play_position.x)
	y_control_input_box.text = str(path_point.out_point.play_position.y)

func initialize(_path_point: PathPoint):
	path_point = _path_point
	path_point.on_path_point_ui_needs_update.connect(update)
	update()

func load_info_to_path_point():
	path_point.load_info_from_info_box(self)

func on_float_input_box_updated(new_string : String) -> void:
	if new_string.is_valid_float():
		load_info_to_path_point()
	else:
		update()

func on_remove_button_pressed():
	var move_event: MoveEvent = path_point.move_event
	move_event.remove_curve_point(path_point.index)
