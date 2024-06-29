extends Control

class_name DragDetector

var following_mouse = false
var mouse_in = false # to be able to start following mouse
var drag_position : Vector2
@export var action_name: String = "left_click"

signal on_clicked()
signal on_dragged(amount: Vector2)
signal on_released()

func _ready():
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
func _process(delta):
	if mouse_in:
		if Input.is_action_just_pressed(action_name):
			drag_position = get_local_mouse_position()
			following_mouse = true
			on_clicked.emit()

	if following_mouse:
		var amount_moved = get_local_mouse_position() - drag_position
		on_dragged.emit(amount_moved)
		if Input.is_action_just_released(action_name):
			following_mouse = false
			on_released.emit()

func on_mouse_entered():
	mouse_in = true
	
func on_mouse_exited():
	mouse_in = false
