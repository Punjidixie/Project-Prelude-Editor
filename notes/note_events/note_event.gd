extends Node

class_name NoteEvent


enum EventType {APPEAR, MOVE, END}

# Local time
@export var start_time: float
@export var event_name: String

@export var event_type: EventType

signal on_event_updated(e: NoteEvent)
signal on_event_ui_needs_update()
signal on_event_deleted()

var note: Note

# Called in Note. Calculate note position based on local_time. Override in inherited classes.
func get_notebody_play_position(local_time: float):
	pass

# Generate and initialize info box. Override in inherited classes.
func get_and_initialize_info_box():
	pass

# Called from info box when it changes. Override in inherited classes.
func load_info_from_info_box(info_box: EventInfoBox):
	pass

# Called from the note to hide. Override in inherited classes.
func set_visible(visible: bool):
	pass
	
# Called from note when a checkpoint changes (and move_all is active)
func move_by(delta_position: Vector2) -> void:
	pass



