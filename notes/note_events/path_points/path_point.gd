extends PlayAreaObject

class_name PathPoint

@export var left_click_drag_detector: DragDetector
@export var right_click_drag_detector: DragDetector
@export var in_point: PlayAreaObject
@export var out_point: PlayAreaObject
@export var control_line: Line2D

var move_event: MoveEvent
var index: int # Which index in move_event's path to control

signal on_path_point_ui_needs_update()

func _ready():
	super._ready()
	left_click_drag_detector.on_dragged.connect(on_left_dragged)
	right_click_drag_detector.on_dragged.connect(on_right_dragged)
	right_click_drag_detector.on_released.connect(on_right_released)
	
	# Why connect them here instead of in events to kill all path point children?
	# Well I don't want all events to get called at once.
	SignalManager.on_move_event_selected.connect(on_move_event_selected)
	SignalManager.on_note_selected.connect(on_note_selected)

func on_viewport_size_changed():
	super.on_viewport_size_changed()
	redraw_control_line()

func initialize(_move_event: MoveEvent, _index: int) -> void:
	self.move_event = _move_event
	self.index = _index
	update()
	
# Called from info box when it changes
func load_info_from_info_box(info_box: PathPointInfoBox):
	var new_play_position = Vector2(float(info_box.x_input_box.text), float(info_box.y_input_box.text))
	var new_out_play_position = Vector2(float(info_box.x_control_input_box.text), float(info_box.y_control_input_box.text))
	set_play_position(new_play_position)
	set_control_world_position(PlayAreaUtils.get_delta_world_position(new_out_play_position))
	move_event.load_info_from_path_point(self)

func get_and_initialize_info_box():
	var info_box : PathPointInfoBox = ScenePreloader.path_point_info_box.instantiate()
	info_box.initialize(self)
	return info_box
	
# Load info from move_event	
func update():
	set_play_position(move_event.path.get_point_position(index))
	set_control_world_position(PlayAreaUtils.get_delta_world_position(move_event.path.get_point_out(index)))
	on_path_point_ui_needs_update.emit()

# Set main position
func on_left_dragged(amount: Vector2) -> void:
	set_world_position(position + amount)
	
	move_event.load_info_from_path_point(self)
	on_path_point_ui_needs_update.emit()

### CONTROL POINTS ###
func on_right_dragged(amount: Vector2) -> void:
	set_control_world_position(out_point.position + amount)
	right_click_drag_detector.position = right_click_drag_detector.position + amount
	
	move_event.load_info_from_path_point(self)
	on_path_point_ui_needs_update.emit()

func on_right_released() -> void:
	right_click_drag_detector.position = Vector2.ZERO
	
func set_control_world_position(out_world_position: Vector2) -> void:
	in_point.set_world_position(-out_world_position)
	out_point.set_world_position(out_world_position)
	redraw_control_line()

func redraw_control_line():
	control_line.clear_points()
	control_line.add_point(in_point.position)
	control_line.add_point(out_point.position)

func on_move_event_selected(move_event: MoveEvent): 
	if move_event != self.move_event: queue_free()

func on_note_selected(note: Note):
	queue_free()

	
