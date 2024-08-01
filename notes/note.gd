extends Node

class_name Note

enum NoteType {CLICK, HOLD, DRAG, FLICK}

@export var note_type: NoteType
@export var start_time: float
@export var note_size: float

@export var note_body : NoteBody
@export var checkpoints_container : Node
@export var note_events_container : Node

@export var start_checkpoint : NoteCheckpoint
@export var end_checkpoint : NoteCheckpoint

@export var appear_event : AppearEvent
@export var end_event : EndEvent

var always_in_time: bool = true
var is_in_time: bool = false
var is_selected: bool = false

signal on_top_ui_needs_update()

func _process(delta):
	if Input.is_action_just_pressed("debug_1"):
		scale_time_by(2)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.on_time_auto_updated.connect(on_time_updated)
	SignalManager.on_time_manual_updated.connect(on_time_updated)
	SignalManager.on_note_selected.connect(on_note_selected)
	SignalManager.on_auto_play_set.connect(on_auto_play_set)
	
	initialize_connections()
	name_all_checkpoints()
	
	# All checkpoints would've been in place by now.
	update_visibility()
	update()
	note_body.update_size() # set size
	
	# Technically not needed, but is here for consistency like in NoteCheckpoint.
	# Nvm it's needed, since "always_in_time" needs to be set to false.
	go_regular_mode() 
	
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
	update_visibility() # visibility / set is_in_time
	update() # position

func on_auto_play_set():
	update() # position (and appearance)

func update():
	# Calculates note body position
	if is_in_time:
		var time = GlobalManager.current_time
		var event = get_event_at_time(time)
		var play_position = event.get_notebody_play_position(time - start_time)
		note_body.set_play_position(play_position)
		note_body.update_appearance()

# Should always be called if the start time or end time change, or the time itself.
func update_visibility():
	if not always_in_time:
		var end_offset = end_event.get_ending_lifetime()
		var time_lower_bound = start_time
		var time_upper_bound = start_time + end_event.start_time + end_offset
		var is_time_out_of_range = not GodotUtils.is_between(GlobalManager.current_time, time_lower_bound, time_upper_bound)
		if is_time_out_of_range and is_in_time: 
			is_in_time = false
			set_visibility(false) # everything goes
		elif not is_time_out_of_range and not is_in_time:
			is_in_time = true
			set_visibility(true) # either just the note body or also with the editor stuffs
	elif always_in_time and not is_in_time:
		is_in_time = true
		set_visibility(true)
	
func load_info_from_info_box(info_box : TopInfoBox) -> void:
	start_time = float(info_box.start_time_input_box.text)
	
	note_size = float(info_box.size_input_box.text)
	note_body.update_size()
	
	var relative_end_time = float(info_box.end_time_input_box.text) - start_time
	end_checkpoint.load_time_from_note(relative_end_time)
	#update_visibility()
	#update() 
	# No need, eventually it will reach the event and both will be picked up.

func on_event_updated(event: NoteEvent):
	if event == end_event:
		on_top_ui_needs_update.emit()
		update_visibility() # the end time might have changed
	update()

# maybe not be needed anymore actually
func on_checkpoint_clicked():
	get_selected()

func get_selected():
	if not is_selected:
		is_selected = true
		SignalManager.on_note_selected.emit(self) # To whom it may concern...
		GlobalManager.selected_note = self
		set_editor_visibility(true) # Will appear for sure, because is_selected is true
		
		# What if the selected note is SOMEHOW outside of the time range...
		# This can really happen, like when confirming the note creation too low.
		is_in_time = true
		update_visibility()
		
func on_note_selected(new_note: Note):
	if new_note != self:
		is_selected = false
		set_editor_visibility(false)
		
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

# Called from the add checkpoint button. Provide a place for the checkpoint to stay.
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
	always_in_time = true

func go_regular_mode():
	note_body.go_regular_mode()
	always_in_time = false
	
func on_creation_confirmed():
	go_regular_mode()
	var checkpoints = get_note_checkpoints()

	var note_distance = checkpoints[0].play_position.y - note_body.play_position.y
	var time_difference = note_distance / GlobalManager.scroll_speed
	
	start_time = GlobalManager.current_time - time_difference

	end_checkpoint.load_time_from_note(checkpoints[0].play_position.y / GlobalManager.scroll_speed)
	# update_visibilty(), update()
	# No need because the end_checkpoint will sort it out.
	
	get_selected()

func on_creation_cancelled():
	queue_free()

func on_creation_zone_exited():
	set_visibility(false)

func on_creation_zone_entered():
	set_visibility(true)

### DELETION ###
func delete(): queue_free()

### VISIBILITY ###
func set_visibility(visibility: bool):
	set_editor_visibility(visibility)
	note_body.visible = visibility
	
func set_editor_visibility(visibility: bool):
	var actual_visibilty = is_selected and visibility
	for checkpoint: NoteCheckpoint in get_note_checkpoints(): checkpoint.visible = actual_visibilty
	for event: NoteEvent in get_note_events(): event.set_visible(actual_visibilty)
	
### TIME AND SPEED ###
func scale_time_by(factor: float):
	for checkpoint: NoteCheckpoint in get_note_checkpoints():
		checkpoint.scale_time_by(factor)
	for event: NoteEvent in get_note_events():
		event.scale_time_by(factor)
	update_visibility()
	update()
	on_top_ui_needs_update.emit()

func set_speed(speed: float):
	var time_factor: float = end_event.end_speed / speed # is 1 / speed factor
	scale_time_by(time_factor)

func load_info_from_midi_note(midi_note: MidiNoteObject) -> void:
	start_time = midi_note.midi_time / 1000.0 - end_event.start_time
	update_visibility()
	update()
	on_top_ui_needs_update.emit()

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
		
