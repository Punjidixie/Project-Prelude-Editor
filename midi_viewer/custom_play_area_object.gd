extends PlayAreaObject

class_name CustomPlayAreaObject

@export var reference_control: Control
@export var scale_vector: Vector2

func update_world_position():
	if coordinate_mode == PlayAreaMode.ABSOLUTE:
		position = PlayAreaUtils.get_custom_world_position(play_position, reference_control, scale_vector)
	else:
		position = PlayAreaUtils.get_custom_delta_world_position(play_position, reference_control, scale_vector)
	print(position)


func update_play_position():
	if coordinate_mode == PlayAreaMode.ABSOLUTE:
		play_position = PlayAreaUtils.get_custom_play_position(position, reference_control, scale_vector)
	else:
		play_position = PlayAreaUtils.get_custom_delta_play_position(position, reference_control, scale_vector)
