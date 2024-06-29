extends Control

class_name PathPointInfoBox

var path_point: PathPoint
@export var x_input: LineEdit
@export var y_input: LineEdit
@export var x_in_input: LineEdit
@export var y_in_input: LineEdit
@export var x_out_input: LineEdit
@export var y_out_input: LineEdit

func update():
	pass

func initialize(_path_point: PathPoint):
	path_point = _path_point
	path_point.on_path_point_ui_needs_update.connect(update)
	update()
