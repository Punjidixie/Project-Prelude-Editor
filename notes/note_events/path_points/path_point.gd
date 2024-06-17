extends PlayAreaObject

class_name PathPoint

@export var drag_detector: DragDetector

var move_event: MoveEvent
var index: int # Which index in move_event's path to control

func _ready():
	drag_detector.on_dragged.connect(on_dragged)

func initialize(_move_event: MoveEvent, _index: int) -> void:
	self.move_event = _move_event
	self.index = _index
	
	set_play_position(move_event.path.get_point_position(index))

func on_dragged(amount: Vector2) -> void:
	set_world_position(position + amount)
	move_event.on_path_point_dragged(index, amount)
	

	
