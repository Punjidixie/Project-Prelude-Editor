extends Node

func get_world_position(play_position: Vector2) -> Vector2:
	var origin_position = GlobalManager.play_area.position + Vector2.DOWN * GlobalManager.play_area.size.y
	var play_position_y_inv = Vector2(1, -1) * play_position
	return origin_position + (GlobalManager.play_area.size * play_position_y_inv / 100)

func get_play_position(world_position: Vector2) -> Vector2:
	var origin_position = GlobalManager.play_area.position + Vector2.DOWN * GlobalManager.play_area.size.y
	var relative_world_pos = world_position - origin_position
	var relative_world_pos_y_inv = Vector2(1, -1) * relative_world_pos
	return (relative_world_pos_y_inv / GlobalManager.play_area.size) * 100

