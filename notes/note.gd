extends Node


class_name Note

@export var start_time : float

@export var note_body : NoteBody
@export var checkpoints_container : Node
@export var note_events_container : Node

@export var end_checkpoint : NoteCheckpoint

@export var appear_event : AppearEvent
@export var end_event : EndEvent

signal on_top_ui_needs_update()

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_time_auto_updated.connect(on_time_updated)
	SignalManager.on_time_manual_updated.connect(on_time_updated)
	
	initialize_connections()
	
	# All checkpoints would've been in place by now.
	update()
	go_regular_mode() # Technically not needed, but is here for consistency like in NoteCheckpoint.
	
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

func load_info_from_midi_note(midi_note: MidiNoteObject) -> void:
	var time_gap = end_event.start_time - start_time
	start_time = midi_note.midi_time - time_gap
	SignalManager.on_top_ui_needs_update.emit()
	update()

func on_event_updated(event: NoteEvent):
	if event == end_event:
		SignalManager.on_top_ui_needs_update.emit()
	update()

func on_checkpoint_clicked():
	if GlobalManager.selected_note != self:
		SignalManager.on_note_selected.emit(self) # Tell the UI manager to spawn UIs
		GlobalManager.selected_note = self

# Called from a checkpoint when it moves. Amount = delta play position
func move_all(amount: Vector2):
	move_by(amount)
	update()

# Amount = delta play position
func move_by(amount: Vector2):
	var checkpoints = get_note_checkpoints()
	var events = get_note_events()
	for checkpoint: NoteCheckpoint in checkpoints: checkpoint.move_by(amount)
	for event: NoteEvent in events: event.move_by(amount)

# Called from the add checkpoint button. Provide a place for the checkpoint to rent.
func add_temporary_checkpoint(checkpoint: NoteCheckpoint):
	connect_checkpoint(checkpoint)
	
	# Set the checkpoint time to sandwich between the last and second last.
	var checkpoints = get_note_checkpoints()
	checkpoint.target_time = (checkpoints[checkpoints.size() - 2].target_time + checkpoints[checkpoints.size() - 1].target_time) / 2
	
	checkpoints_container.add_child(checkpoint)
	checkpoint.go_creation_mode() # Can now go creation mode, as _ready() has been called over there.

func add_checkpoint(checkpoint: NoteCheckpoint):
	checkpoint.go_regular_mode()
	
	# Add info box
	var new_info_box = checkpoint.get_and_initialize_info_box()
	SignalManager.on_new_checkpoint_info_box_added.emit(new_info_box)
	SignalManager.on_checkpoint_info_boxes_need_reordering.emit()
	
	name_all_checkpoints()

func add_move_event(event: MoveEvent):
	connect_event(event)
	
	# Set the event time to be sandwiched between the last and second last.
	var events = get_note_events()
	event.start_time = (events[events.size() - 2].start_time + events[events.size() - 1].start_time) / 2
	
	note_events_container.add_child(event)
	
	# Add info box
	var new_info_box = event.get_and_initialize_info_box()
	SignalManager.on_new_event_info_box_added.emit(new_info_box)
	SignalManager.on_event_info_boxes_need_reordering.emit()
	
	update()

# Rename all checkpoints
func name_all_checkpoints():
	var checkpoints = get_note_checkpoints()
	for i in range(checkpoints.size()):
		var checkpoint: NoteCheckpoint = checkpoints[i]
		if checkpoint.checkpoint_name != "Start" and checkpoint.checkpoint_name != "End":
			checkpoint.rename("Checkpoint %s" % i) # Will emit the info box update signal too

### CREATION ###
func go_creation_mode():
	note_body.go_creation_mode()

func go_regular_mode():
	note_body.go_regular_mode()
	
func on_creation_confirmed():
	go_regular_mode()
	var checkpoints = get_note_checkpoints()

	var note_distance = checkpoints[0].play_position.y - note_body.play_position.y
	var time_difference = note_distance / GlobalManager.scroll_speed
	
	start_time = GlobalManager.current_time - time_difference

	on_checkpoint_clicked() # As if the note gets selected
	end_checkpoint.load_time_from_note(checkpoints[0].play_position.y / GlobalManager.scroll_speed)
	# update()
	# No need because the end_checkpoint will sort it out.

func on_creation_cancelled():
	queue_free()

func on_creation_zone_exited():
	for checkpoint in get_note_checkpoints(): checkpoint.visible = false
	for event: NoteEvent in get_note_events(): event.set_visible(false)
	note_body.visible = false

func on_creation_zone_entered():
	for checkpoint in get_note_checkpoints(): checkpoint.visible = true
	for event: NoteEvent in get_note_events(): event.set_visible(true)
	note_body.visible = true

### DELETION ###
func delete(): queue_free()

### UTILITY FUNCTIONS BELOW ###

func get_event_at_time(time: float):
	var local_time = time - start_time
	var note_events = get_note_events()
	for i in range(note_events.size() -1, -1, -1):
		if local_time > note_events[i].start_time:
			return note_events[i]
	
	return note_events[0]
	
func get_note_checkpoints() -> Array:
	var note_checkpoints = checkpoints_container.get_children()
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

func get_and_initialize_top_info_box() -> TopInfoBox:
	var top_info_box: TopInfoBox = ScenePreloader.top_info_box.instantiate()
	top_info_box.initialize(self)
	return top_info_box

func get_event_info_boxes() -> Array:
	var note_events = get_note_events()
	var info_boxes = Array()
	for event in note_events:
		info_boxes.append(event.get_and_initialize_info_box())
	
	return info_boxes
		
