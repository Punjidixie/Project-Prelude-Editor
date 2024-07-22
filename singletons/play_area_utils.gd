extends Node

const scale_factor = 480

### DEFAULT CALCULATION ###
func get_world_position(play_position: Vector2) -> Vector2:
	return get_custom_world_position(play_position, GlobalManager.play_area, Vector2.ONE * scale_factor)
	
func get_play_position(world_position: Vector2) -> Vector2:
	return get_custom_play_position(world_position, GlobalManager.play_area, Vector2.ONE * scale_factor)

func get_delta_world_position(play_position: Vector2) -> Vector2:
	return get_custom_delta_world_position(play_position, GlobalManager.play_area, Vector2.ONE * scale_factor)
	
func get_delta_play_position(world_position: Vector2) -> Vector2:
	return get_custom_delta_play_position(world_position, GlobalManager.play_area, Vector2.ONE * scale_factor)
	
### CUSTOM CALCULATION ###
func get_custom_world_position(play_position: Vector2, reference_control: Control, scale_vector: Vector2) -> Vector2:
	var origin_position = reference_control.position + Vector2.DOWN * reference_control.size.y
	var play_position_y_inv = Vector2(1, -1) * play_position
	return origin_position + (reference_control.size * play_position_y_inv / scale_vector)

func get_custom_play_position(world_position: Vector2, reference_control: Control, scale_vector: Vector2) -> Vector2:
	var origin_position = reference_control.position + Vector2.DOWN * reference_control.size.y
	var relative_world_pos = world_position - origin_position
	var relative_world_pos_y_inv = Vector2(1, -1) * relative_world_pos
	return (relative_world_pos_y_inv / reference_control.size) * scale_vector

func get_custom_delta_play_position(delta_world_position: Vector2, reference_control: Control, scale_vector: Vector2) -> Vector2:
	var delta_world_position_y_inv = Vector2(1, -1) * delta_world_position
	return (delta_world_position_y_inv / reference_control.size) * scale_vector

func get_custom_delta_world_position(delta_play_position: Vector2, reference_control: Control, scale_vector: Vector2) -> Vector2:
	var delta_play_position_y_inv = Vector2(1, -1) * delta_play_position
	return reference_control.size * delta_play_position_y_inv / scale_vector
