extends Node


class_name Note

@export var start_time : float

@export var note_body : PlayAreaObject
@export var checkpoints_container : Node
@export var note_events_container : Node

@export var end_checkpoint : NoteCheckpoint

@export var appear_event : AppearEvent
@export var end_event : EndEvent

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_time_auto_updated.connect(on_time_updated)
	SignalManager.on_time_manual_updated.connect(on_time_updated)
	
	initialize_connections()
	
func initialize_connections():
	for checkpoint in get_note_checkpoints():
		connect_checkpoint(checkpoint)
	for event in get_note_events():
		connect_event(event)

func connect_checkpoint(checkpoint: NoteCheckpoint):
	# Checkpoints are only there to be used by events.
	# Checkpoint changes will be picked up by events, and events will update accordingly then emit signals.
	# checkpoint.on_checkpoint_updated.connect(on_checkpoint_updated)
	checkpoint.note = self

func connect_event(event: NoteEvent):
	event.on_event_updated.connect(on_event_updated)
	event.note = self

func on_time_updated():
	update()

func update():

	# Calculates note body position
	var time = GlobalManager.current_time
	var event = get_event_at_time(time)
	var play_position = event.get_notebody_play_position(time - start_time)
	note_body.set_play_position(play_position)

func load_info_from_info_box(info_box : TopInfoBox) -> void:
	start_time = float(info_box.start_time_input_box.text)
	var relative_end_time = float(info_box.end_time_input_box.text) - start_time
	
	end_checkpoint.load_time_from_note(relative_end_time)
	#update() 
	# No need, eventually it will reach the event and will be picked up.

func on_event_updated(event: NoteEvent):
	if event == end_event:
		SignalManager.on_top_ui_needs_update.emit()
	update()

func on_checkpoint_clicked():
	if GlobalManager.selected_note != self:
		SignalManager.on_note_selected.emit(self) # Tell the UI manager to spawn UIs
		GlobalManager.selected_note = self

# Called from a checkpoint when it moves
func move_all(amount: Vector2):
	var checkpoints = get_note_checkpoints()
	var events = get_note_events()
	for checkpoint: NoteCheckpoint in checkpoints: checkpoint.move_by(amount)
	for event: NoteEvent in events: event.move_by(amount)
	update()

# Called from the add checkpoint button. Provide a place for the checkpoint to rent.
func add_temporary_checkpoint(checkpoint: NoteCheckpoint):
	connect_checkpoint(checkpoint)
	checkpoints_container.add_child(checkpoint)
	checkpoint.go_creation_mode() # Can now go creation mode, as _ready() has been called over there.

func add_checkpoint(checkpoint: NoteCheckpoint):
	checkpoint.go_regular_mode()
	
	# Add info box
	var new_info_box = checkpoint.get_and_initialize_info_box()
	SignalManager.on_new_checkpoint_info_box_added.emit(new_info_box)
	
	name_all_checkpoints() # Will emit reordering too

func add_event(event: MoveEvent):
	connect_event(event)
	note_events_container.add_child(event)
	event.redraw_curve()
	
	# Add info box
	var new_info_box = event.get_and_initialize_info_box()
	SignalManager.on_new_event_info_box_added.emit(new_info_box)
	SignalManager.on_event_info_boxes_need_reordering.emit()

# Rename and reorder info boxes
func name_all_checkpoints():
	var checkpoints = get_note_checkpoints()
	for i in range(checkpoints.size()):
		var checkpoint: NoteCheckpoint = checkpoints[i]
		if checkpoint.checkpoint_name != "Start" and checkpoint.checkpoint_name != "End":
			checkpoint.rename("Checkpoint %s" % i) # Will emit the info box update signal too
	
	# Emit here rather than from the info boxes so it gets emitted only once.
	SignalManager.on_checkpoint_info_boxes_need_reordering.emit()
		
### UTILITY FUNCTIONS BELOW ###

func get_event_at_time(time: float):
	var local_time = time - start_time
	var note_events = get_note_events()
	var selected_event : NoteEvent
	for i in range(note_events.size() -1, -1, -1):
		if local_time > note_events[i].start_time:
			return note_events[i]
	
	return note_events[0]
	
func get_note_checkpoints() -> Array:
	var note_checkpoints = checkpoints_container.get_children()
	print(note_checkpoints.size())
	note_checkpoints.sort_custom(SortingFunctions.compare_note_checkpoints)
	return note_checkpoints

func get_note_events() -> Array:
	var note_events = note_events_container.get_children()
	
	note_events.sort_custom(SortingFunctions.compare_note_events)
	return note_events
		
func get_checkpoint_info_boxes() -> Array:
	var note_checkpoints = get_note_checkpoints()
	var info_boxes = Array()
	for checkpoint in note_checkpoints:
		info_boxes.append(checkpoint.get_and_initialize_info_box())
	
	return info_boxes

func get_event_info_boxes() -> Array:
	var note_events = get_note_events()
	var info_boxes = Array()
	for event in note_events:
		info_boxes.append(event.get_and_initialize_info_box())
	
	return info_boxes
		
