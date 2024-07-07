extends Node

@export var horizontal_line_color: Color
@export var horizontal_line_width: float

@export var horizontal_lines: Node
@export var vertical_lines: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_time_auto_updated.connect(update_horizontal)
	SignalManager.on_time_manual_updated.connect(update_horizontal)
	SignalManager.on_grid_drawer_needs_update.connect(update)
	get_tree().get_root().size_changed.connect(update)

func update():
	update_horizontal()
	update_vertical()

func update_horizontal():
	if GlobalManager.is_static_grid:
		update_horizontal_static()
	else:
		update_horizontal_dynamic()
	
func update_horizontal_dynamic():
	GodotUtils.delete_all_children(vertical_lines)
	var next_beat_y_position = GridUtils.get_next_beat_y_position()
	var gap = GridUtils.get_units_per_beat()
	var i = 0 # For the ith line
	while true:
		var line_y = next_beat_y_position + gap * i
		if line_y > 100: break
		
		# Create a new line
		var l = Line2D.new()
		vertical_lines.add_child(l)
		l.width = horizontal_line_width
		l.default_color = horizontal_line_color
		l.add_point(PlayAreaUtils.get_world_position(Vector2(0, line_y)))
		l.add_point(PlayAreaUtils.get_world_position(Vector2(100, line_y)))
		
		i += 1

func update_horizontal_static():
	GodotUtils.delete_all_children(horizontal_lines)
	var i = 0
	while true:

		var line_y: float = 100 * (float(i) / float(GlobalManager.horizontal_divisions))
		if line_y > 100: break

		# Create a new line
		var l = Line2D.new()
		horizontal_lines.add_child(l)
		l.width = horizontal_line_width
		l.default_color = horizontal_line_color

		l.add_point(PlayAreaUtils.get_world_position(Vector2(0, line_y)))
		l.add_point(PlayAreaUtils.get_world_position(Vector2(100, line_y)))
		
		i += 1

func update_vertical():
	GodotUtils.delete_all_children(horizontal_lines)
	var i = 0
	while true:

		var line_x: float = 100 * (float(i) / float(GlobalManager.vertical_divisions))
		if line_x > 100: break

		# Create a new line
		var l = Line2D.new()
		horizontal_lines.add_child(l)
		l.width = horizontal_line_width
		l.default_color = horizontal_line_color

		l.add_point(PlayAreaUtils.get_world_position(Vector2(line_x, 0)))
		l.add_point(PlayAreaUtils.get_world_position(Vector2(line_x, 100)))
		
		i += 1
		
func get_time_from_beat(beat: float):
	# beat * (seconds per beat)
	return beat / (GlobalManager.bpm / 60) + GlobalManager.time_offset

func get_beat_from_time(time: float):
	# time * (beats per sec)
	return (time - GlobalManager.time_offset) * (GlobalManager.bpm / 60)
	
