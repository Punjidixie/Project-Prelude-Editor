extends NoteBody

class_name HoldNoteBody

@export var hold_body: Control

func _ready():
	super._ready()
	get_tree().get_root().size_changed.connect(update_height)

# Horizontal size changes if HoldNote.note_size changes.
# That is super.update_size().

# Vertical size should be re-calculated if the following changed...
# 1. HoldNote.hold_time
# 2. position AKA update(), which can be cause by these variables related to the calculation.
# 2.1 GlobalManager.current_time
# 2.2 HoldNote.start_time
# 2.3 HoldEndEvent.start_time
# 2.4 HoldEndEvent.end_speed
# 2.5 GlobalManager.is_auto_play
# This should be called where those change.
func update_height(consider_auto_play: bool = true):
	var hold_note := note as HoldNote
	var remaining_hold_time = hold_note.hold_time
	if GlobalManager.is_auto_play and consider_auto_play:
		var relative_time = GlobalManager.current_time - hold_note.start_time
		var time_since_end = relative_time - hold_note.end_event.start_time
		remaining_hold_time = clampf(hold_note.hold_time - time_since_end, 0, hold_note.hold_time)

	var play_height = hold_note.end_event.end_speed * remaining_hold_time
	var world_height = - PlayAreaUtils.get_delta_world_position(Vector2(0, play_height))
	
	hold_body.size.y = world_height.y / body.scale.y
	hold_body.position.y = (body.size.y / 2) - hold_body.size.y
	# x position is anchored to the body as 0.

func update_appearance():
	if GlobalManager.is_auto_play:
		pass
	
