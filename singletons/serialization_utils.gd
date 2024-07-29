extends Node

func serialize_chart(notes: Array):
	var note_dicts = []
	for note: Note in notes:
		note_dicts.append(serialize_note(note))
	
	var chart_dict = {
		notes = note_dicts
	}
	
	return chart_dict
	
func serialize_note(note: Note):
	var note_dict = {
		type = note.note_type,
		t = note.start_time,
		size = note.note_size,
		end_speed = note.end_event.end_speed,
		checkpoints = [],
		events = []
	}
	
	for checkpoint: NoteCheckpoint in note.get_note_checkpoints():
		note_dict.checkpoints.append(serialize_checkpoint(checkpoint))
	
	for event: NoteEvent in note.get_note_events():
		if event.event_type == event.EventType.MOVE:
			note_dict.events.append(serialize_move_event(event))
			
	return note_dict
	
	
func serialize_checkpoint(checkpoint: NoteCheckpoint):
	var checkpoint_dict = {
		t = checkpoint.target_time,
		x = checkpoint.play_position.x,
		y = checkpoint.play_position.y
	}
	
	if checkpoint.checkpoint_type in [checkpoint.CheckpointType.START, checkpoint.CheckpointType.END]:
		checkpoint_dict.type = checkpoint.checkpoint_type

	return checkpoint_dict

func serialize_move_event(move_event: MoveEvent):
	var move_event_dict = {
		t = move_event.start_time,
		points_x = [],
		points_y = [],
		controls_x = [],
		controls_y = []
	}
	
	# Set path points
	for i in range(move_event.path.point_count):
		var point = move_event.path.get_point_position(i)
		var out = move_event.path.get_point_out(i)
		
		move_event_dict.points_x.append(point.x)
		move_event_dict.points_y.append(point.y)
		
		# Don't add control points at the tips.
		if i != 0 and i != move_event.path.point_count - 1:
			move_event_dict.controls_x.append(out.x)
			move_event_dict.controls_y.append(out.y)
	
	var checkpoints = move_event.note.get_note_checkpoints()
	# Set start and dest
	if is_instance_valid(move_event.start_checkpoint):
		move_event_dict.start = checkpoints.find(move_event.start_checkpoint)
	if is_instance_valid(move_event.destination_checkpoint):
		move_event_dict.dest = checkpoints.find(move_event.destination_checkpoint)
	return move_event_dict

func deserialize_note(note_dict: Dictionary):
	var note: Note = ScenePreloader.base_note.instantiate()
	
	note.start_time = note_dict.t
	note.note_size = note_dict.size
	note.end_event.end_speed = note_dict.end_speed
	
	for checkpoint_dict in note_dict.checkpoints:
		match checkpoint_dict.type:
			note.start_checkpoint.CheckpointType.START:
				load_info_to_checkpoint(checkpoint_dict, note.start_checkpoint)
			note.end_checkpoint.CheckpointType.END:
				load_info_to_checkpoint(checkpoint_dict, note.end_checkpoint)
			_:
				var checkpoint: NoteCheckpoint = ScenePreloader.base_note.instantiate()
				load_info_to_checkpoint(checkpoint_dict, checkpoint)
				note.checkpoints_container.add_child(checkpoint)
	
	for move_event_dict in note_dict.events:
		var move_event = deserialize_move_event(move_event_dict, note)
		note.note_events_container.add_child(move_event)
	
	return note

func deserialize_move_event(move_event_dict: Dictionary, note: Note):
	var move_event: MoveEvent = ScenePreloader.move_event.instantiate()
	
	move_event.start_time = move_event_dict.t
	
	move_event.path.clear_points()
	for i in range(move_event_dict.points_x.size()):
		var point = Vector2(move_event_dict.points_x[i], move_event_dict.points_y[i])
		move_event.path.add_point(point)
	# In the dict, control point index 0 corresponds to point index 1.
	# The first and the last control points weren't included.
	for i in range(1, move_event_dict.points_x.size() - 1):
		var out = Vector2(move_event_dict.controls_x[i - 1], move_event_dict.controls_y[i - 1])
		move_event.path.set_point_out(i, out)
		move_event.path.set_point_in(i, -out)
	
	if "start" in move_event_dict:
		move_event.start_checkpoint = note.get_note_checkpoints()[move_event_dict.start]
	if "dest" in move_event_dict:
		move_event.destination_checkpoint = note.get_note_checkpoints()[move_event_dict.dest]
	
	return move_event

func load_info_to_checkpoint(checkpoint_dict: Dictionary, checkpoint: NoteCheckpoint):
	checkpoint.target_time = checkpoint_dict.t
	checkpoint.play_position = Vector2(checkpoint_dict.x, checkpoint_dict.y)
	
	if "type" in checkpoint_dict:
		checkpoint.checkpoint_type = checkpoint_dict.type	
	
	
	


	
	
	
