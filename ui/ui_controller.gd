extends Node

@export var checkpoint_container : Control
@export var event_container : Control
@export var top_info_box : TopInfoBox
@export var time_input_box : LineEdit

@export var sample_note : Note

func _process(delta):
	SignalManager.on_note_selected.connect(populate_note_ui)
		
		
func populate_note_ui(note: Note) -> void:
	# Clean up
	clear_note_ui()
	
	# Update top info
	top_info_box.initialize(note)
	
	# Repopulate checkpoints
	# Info boxes will be initialized too.
	var checkpoint_info_boxes = note.get_checkpoint_info_boxes()
	for info_box in checkpoint_info_boxes:
		checkpoint_container.add_child(info_box)
	
	# Repopulate events
	# Info boxes will be initialized too.
	var event_info_boxes = note.get_event_info_boxes()
	for info_box in event_info_boxes:
		event_container.add_child(info_box)

func clear_note_ui() -> void:
	GodotUtils.delete_all_children(checkpoint_container)
	GodotUtils.delete_all_children(event_container)


