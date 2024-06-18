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
	SignalManager.move_all_by.connect(on_move_all)
	
	initialize_connections()
	
func initialize_connections():
	for checkpoint in get_note_checkpoints():
		connect_checkpoint(checkpoint)
	for event in get_note_events():
		connect_event(event)

func connect_checkpoint(checkpoint: NoteCheckpoint):
	# Checkpoints are only there to be used by events.
	# Checkpoint changes will be picked up by events, and events will update accordingly then emit signals.
	#checkpoint.on_checkpoint_updated.connect(on_checkpoint_updated)
	
	checkpoint.on_checkpoint_clicked.connect(on_checkpoint_clicked)

func connect_event(event: NoteEvent):
	event.on_event_updated.connect(on_event_updated)

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
	# No need, because end_checkpoint.load_time_from_note will have emitted the change signal anyway

func on_event_updated(event: NoteEvent):
	if event == end_event:
		SignalManager.on_top_ui_needs_update.emit()
	update()

func on_checkpoint_clicked(): 
	SignalManager.on_note_selected.emit(self) # Tell the UI manager to spawn UIs

func on_move_all(amount: Vector2):
	var checkpoints = get_note_checkpoints()
	var events = get_note_events()
	for checkpoint: NoteCheckpoint in checkpoints: checkpoint.move_by(amount)
	for event: NoteEvent in events: event.move_by(amount)
	update()

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
		
