extends Node

@export var horizontal_line_color: Color
@export var horizontal_line_width: float

@export var subdivision_line_color: Color
@export var subdivision_line_width: float

@export var vertical_line_color: Color
@export var vertical_line_width: float

@export var border_line_color: Color
@export var border_line_width: float

@export var horizontal_lines: Node
@export var vertical_lines: Node
@export var border_lines: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_time_auto_updated.connect(on_time_updated)
	SignalManager.on_time_manual_updated.connect(on_time_updated)
	SignalManager.on_grid_drawer_needs_update.connect(update)
	get_tree().get_root().size_changed.connect(update)

func update():
	generate_and_update_vertical()
	generate_and_update_border()
	generate_horizontal()
	update_horizontal()
	
func on_time_updated():
	if GlobalManager.is_static_grid == false:
		update_horizontal()

func generate_and_update_border():
	GodotUtils.delete_all_children(border_lines)
	# Left border
	var left_line = GodotUtils.create_line(Vector2(GridUtils.get_lower_left_border().x, GridUtils.get_lower_left_border().y), Vector2(GridUtils.get_lower_left_border().x, GridUtils.get_upper_right_border().y), border_line_width, border_line_color)
	# Right border
	var right_line = GodotUtils.create_line(Vector2(GridUtils.get_upper_right_border().x, GridUtils.get_lower_left_border().y), Vector2(GridUtils.get_upper_right_border().x, GridUtils.get_upper_right_border().y), border_line_width, border_line_color)
	# Top border
	var top_line = GodotUtils.create_line(Vector2(GridUtils.get_lower_left_border().x, GridUtils.get_upper_right_border().y), Vector2(GridUtils.get_upper_right_border().x, GridUtils.get_upper_right_border().y), border_line_width, border_line_color)
	# Bottom border
	var bottom_line = GodotUtils.create_line(Vector2(GridUtils.get_lower_left_border().x, GridUtils.get_lower_left_border().y), Vector2(GridUtils.get_upper_right_border().x, GridUtils.get_lower_left_border().y), border_line_width, border_line_color)
	for line in [left_line, right_line, top_line, bottom_line]: border_lines.add_child(line)
	
	
func generate_and_update_vertical():
	GodotUtils.delete_all_children(vertical_lines)
	var gap_per_line = PlayAreaUtils.scale_factor / float(GlobalManager.vertical_divisions)
	var num_lines_right: int = (GridUtils.get_upper_right_border().x) / gap_per_line
	var num_lines_left: int = (-GridUtils.get_lower_left_border().x) / gap_per_line
	for i in range(-num_lines_left, num_lines_right + 1):
		var line_x: float = i * gap_per_line
		var line = GodotUtils.create_line(Vector2(line_x, GridUtils.get_lower_left_border().y), Vector2(line_x, GridUtils.get_upper_right_border().y), vertical_line_width, vertical_line_color)
		vertical_lines.add_child(line)

func generate_horizontal():
	var gap_per_line: float
	
	if GlobalManager.is_static_grid == false:
		gap_per_line = GridUtils.get_units_per_beat() / GlobalManager.subdivisions
	else:
		gap_per_line = PlayAreaUtils.scale_factor / float(GlobalManager.horizontal_divisions)
	
	var max_distance = GridUtils.get_upper_right_border().y - GridUtils.get_lower_left_border().y
	var num_lines: int= floor(max_distance / gap_per_line)
	
	GodotUtils.delete_all_children(horizontal_lines)
	for i in range(num_lines + 1):
		horizontal_lines.add_child(Line2D.new())

func update_horizontal():
	var gap_per_line: float
	var origin_y: float
	
	if GlobalManager.is_static_grid == false:
		gap_per_line = GridUtils.get_units_per_beat() / GlobalManager.subdivisions
		origin_y = GridUtils.get_next_beat_y_position()
	else:
		gap_per_line = PlayAreaUtils.scale_factor / float(GlobalManager.horizontal_divisions)
		origin_y = 0
		
	# How many lines is the bottom line away from the origin line?
	var index_offset: int = floor((origin_y - GridUtils.get_lower_left_border().y) / gap_per_line)
	var first_line_y = origin_y - index_offset * gap_per_line
	
	for i in range(horizontal_lines.get_child_count()):
		var line: Line2D = horizontal_lines.get_child(i)
		var line_y = first_line_y + gap_per_line * i
		if not GridUtils.is_in_zone(PlayAreaUtils.get_world_position(Vector2(0, line_y))):
			line.visible = false
			continue
		else:
			line.visible = true
		
		var color: Color = horizontal_line_color
		var width: float = horizontal_line_width
		if (i - index_offset) % GlobalManager.subdivisions != 0 and GlobalManager.is_static_grid == false:
			color = subdivision_line_color
			width = subdivision_line_width
		
		var left_point = PlayAreaUtils.get_world_position(Vector2(GridUtils.get_lower_left_border().x, line_y))
		var right_point = PlayAreaUtils.get_world_position(Vector2(GridUtils.get_upper_right_border().x, line_y))
		line.clear_points()
		line.add_point(left_point)
		line.add_point(right_point)
		line.width = width
		line.default_color = color

func old_update_horizontal():
	GodotUtils.delete_all_children(horizontal_lines)
	
	var gap_per_line: float
	var origin_y: float
	
	if GlobalManager.is_static_grid == false:
		gap_per_line = GridUtils.get_units_per_beat() / GlobalManager.subdivisions
		origin_y = GridUtils.get_next_beat_y_position()
	else:
		gap_per_line = PlayAreaUtils.scale_factor / float(GlobalManager.horizontal_divisions)
		origin_y = 0

	var num_lines_up: int = (GridUtils.get_upper_right_border().y - origin_y) / gap_per_line
	var num_lines_down: int = (origin_y - GridUtils.get_lower_left_border().y) / gap_per_line
	for i in range(-num_lines_down, num_lines_up + 1):
		# Check if the line is a main beat or a subdivision
		var color: Color = horizontal_line_color
		var width: float = horizontal_line_width
		if i % GlobalManager.subdivisions != 0 and GlobalManager.is_static_grid == false:
			color = subdivision_line_color
			width = subdivision_line_width
		
		var line_y: float = origin_y + i * gap_per_line
		var line = GodotUtils.create_line(Vector2(GridUtils.get_lower_left_border().x, line_y), Vector2(GridUtils.get_upper_right_border().x, line_y), width, color)
		horizontal_lines.add_child(line)
