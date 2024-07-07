extends Node

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

func get_closest_intersection(world_position: Vector2):
	# On each axis, how far away is the position from the reference position?
	# And how many multiples of the gap per line is that?
	
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
		gap_per_line.y = get_units_per_beat() * GlobalManager.subdivisions
	
	# Calculate
	var delta_position = play_position - reference_position
	# How many multiples of gap per line?
	var closest_multiple = Vector2(round(delta_position.x / gap_per_line.x), round(delta_position.y / gap_per_line.y))
	
	var closest = reference_position + closest_multiple * gap_per_line

	return PlayAreaUtils.get_world_position(closest)
