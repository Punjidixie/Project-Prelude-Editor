extends Node

const lower_left_extension = Vector2(10, 10)
const upper_right_extension = Vector2(10, 10)

func get_lower_left_border() -> Vector2:
	return -lower_left_extension

func get_upper_right_border() -> Vector2:
	return Vector2.ONE * PlayAreaUtils.scale_factor + upper_right_extension

# Play position!
func get_next_beat_y_position():
	var next_beat: int = ceil(get_beat_from_time(GlobalManager.current_time))
	var next_beat_time = get_time_from_beat(next_beat)
	var delta_time = next_beat_time - GlobalManager.current_time
	var delta_position = delta_time * GlobalManager.scroll_speed
	
	return delta_position
	
# Play position!
func get_units_per_beat():
	# (units/sec) * (seconds/beat) = units/sec
	return GlobalManager.scroll_speed / (GlobalManager.bpm / 60)

func get_time_from_beat(beat: float):
	# beat * (seconds per beat)
	return beat / (GlobalManager.bpm / 60) + GlobalManager.time_offset

func get_beat_from_time(time: float):
	# time * (beats per sec)
	return (time - GlobalManager.time_offset) * (GlobalManager.bpm / 60)

func get_snapped_position(world_position: Vector2):
	# On each axis, how far away is the position from the reference position?
	# And how many multiples of the gap per line is that? Yeah. I'll round it.
	
	var play_position = PlayAreaUtils.get_play_position(world_position)
	
	# Initialize variables
	var reference_position = Vector2(0, 0) # Origin
	var gap_per_line = Vector2(0, 0) # x = gap of vertical lines, y = gap of horizontal lines
	
	# Set variables
	gap_per_line.x = float(PlayAreaUtils.scale_factor) / float(GlobalManager.vertical_divisions)
	
	if GlobalManager.is_static_grid:
		gap_per_line.y = float(PlayAreaUtils.scale_factor) / float(GlobalManager.horizontal_divisions)
	else:
		reference_position.y = get_next_beat_y_position()
		gap_per_line.y = get_units_per_beat() / GlobalManager.subdivisions
	
	# Calculate
	var delta_position = play_position - reference_position
	# Find how many multiples of gap there are per line.
	var closest_multiple = Vector2(round(delta_position.x / gap_per_line.x), round(delta_position.y / gap_per_line.y))
	
	# Snap to the grid.
	var closest_intersection = reference_position + closest_multiple * gap_per_line
	
	# Check if it's closer to the border lines.
	# Why snap to the border here too? 
	# If we only rely on border limiting, we would have to wait until the position gets snapped somewhere outside the border for the limiting to take place.
	var closest = get_border_snapped_position(closest_intersection, play_position)


	return PlayAreaUtils.get_world_position(closest)

# If the original position is somehow closer to the border than the grid, snap to the border instead.
func get_border_snapped_position(grid_position: Vector2, original_position: Vector2):
	var output = original_position

	var closest_y = GodotUtils.get_closest_number([get_upper_right_border().y, get_lower_left_border().y, grid_position.y], original_position.y)
	var closest_x = GodotUtils.get_closest_number([get_upper_right_border().x, get_lower_left_border().x, grid_position.x], original_position.x)
	
	return Vector2(closest_x, closest_y)
	
