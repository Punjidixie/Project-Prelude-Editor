extends Node

class_name EventInfoBox

@export var event_name_label: Label

var event: NoteEvent

# Called from the parent event.
func initialize(_event: NoteEvent):
	event = _event
	event.on_event_ui_needs_update.connect(update)
	update()
	
# Load data from the event. Override this in inherited classes.
func update():
	event_name_label.text = event.name

# Called when the manual changes to the info box are made.
# Call this in inherited classes.
func load_info_to_checkpoint() -> void:
	event.load_info_from_info_box(self)
