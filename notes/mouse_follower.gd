extends Node2D

class_name MouseFollower

signal on_moved(amount: Vector2)
signal on_confirmed
signal on_cancelled

func _process(_delta):
	var amount = get_local_mouse_position()
	on_moved.emit(amount)
	
	if Input.is_action_just_pressed("left_click"):
		on_confirmed.emit()
	if Input.is_action_just_pressed("right_click"):
		on_cancelled.emit()
