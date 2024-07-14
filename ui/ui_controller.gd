extends Node

@export var checkpoint_container : Control
@export var event_container : Control
@export var top_ui_container: Control


func _ready():
	SignalManager.on_note_selected.connect(on_note_selected)
	SignalManager.on_checkpoint_info_boxes_need_reordering.connect(reorder_checkpoint_info_boxes)
	SignalManager.on_event_info_boxes_need_reordering.connect(reorder_event_info_boxes)
	SignalManager.on_new_checkpoint_info_box_added.connect(add_checkpoint_info_box)
	SignalManager.on_new_event_info_box_added.connect(add_event_info_box)
		
func on_note_selected(note: Note) -> void:
	clear_note_ui()
	if is_instance_valid(note):
		populate_note_ui(note)
		
func populate_note_ui(note: Note) -> void:
	# Update top info
	var top_info_box = note.get_and_initialize_top_info_box()
	
	top_ui_container.add_child(top_info_box)
	
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

func reorder_checkpoint_info_boxes():
	GodotUtils.sort_children(checkpoint_container, SortingFunctions.compare_note_checkpoint_info_boxes)

func reorder_event_info_boxes():
	GodotUtils.sort_children(event_container, SortingFunctions.compare_note_event_info_boxes)

func add_checkpoint_info_box(info_box: CheckpointInfoBox):
	checkpoint_container.add_child(info_box)
	
func add_event_info_box(info_box: EventInfoBox):
	event_container.add_child(info_box)
	
func clear_note_ui() -> void:
	GodotUtils.delete_all_children(checkpoint_container)
	GodotUtils.delete_all_children(event_container)
	GodotUtils.delete_all_children(top_ui_container)


