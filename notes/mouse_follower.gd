extends Node2D

class_name MouseFollower

signal on_moved(amount: Vector2)
signal on_zone_entered
signal on_zone_exited
signal on_confirmed
signal on_cancelled

var is_in_zone: bool = true

func _process(_delta):
	if is_in_zone == true:
		if GridUtils.is_in_zone(get_global_mouse_position()) == false:
			on_zone_exited.emit()
			is_in_zone = false
		else:
			emit_move_signals()

	elif is_in_zone == false:
		if GridUtils.is_in_zone(get_global_mouse_position()) == true:
			on_zone_entered.emit()
			is_in_zone = true
			emit_move_signals()
		else:
			if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
				on_cancelled.emit()

func emit_move_signals():
	var snapped_mouse_position = GridUtils.get_snapped_position(get_global_mouse_position())
	on_moved.emit(snapped_mouse_position - global_position)

	if Input.is_action_just_pressed("left_click"):
		on_confirmed.emit()
	if Input.is_action_just_pressed("right_click"):
		on_cancelled.emit()
			

		
	
