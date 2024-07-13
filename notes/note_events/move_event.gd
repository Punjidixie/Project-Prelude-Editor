extends NoteEvent


class_name MoveEvent

@export var path : Curve2D
@export var start_checkpoint : NoteCheckpoint
@export var destination_checkpoint : NoteCheckpoint

@export var visual_curve : Line2D

@export var path_points: Node

func _ready():
	get_tree().get_root().size_changed.connect(on_viewport_size_changed)
	connect_start_checkpoint()
	connect_destination_checkpoint()
	redraw_curve()

# get the current note's play position from local time
func get_notebody_play_position(local_time: float):
	var current_path_time = local_time - start_time
	var total_path_time = destination_checkpoint.target_time - start_time
	var progress_ratio = current_path_time / total_path_time
	return path.sample_baked(path.get_baked_length() * progress_ratio)

func get_and_initialize_info_box():
	var info_box : MoveEventInfoBox = ScenePreloader.move_event_info_box.instantiate()
	info_box.initialize(self)
	return info_box

# Called from info box when it changes
func load_info_from_info_box(info_box: EventInfoBox):
	var move_event_box := info_box as MoveEventInfoBox
	start_time = float(move_event_box.time_input_box.text)
	on_event_updated.emit(self)

func move_by(delta_position: Vector2) -> void:
	# UI doesn't need to be updated. Note knows already (because that's who called this).
	# The signals don't need to be emitted.
	for i in range(path.point_count):
		var new_point_position = path.get_point_position(i) + delta_position
		path.set_point_position(i, new_point_position)
	redraw_curve()
	
	for path_point: PathPoint in path_points.get_children():
		path_point.update()

func set_visible(visible: bool):
	for path_point: PathPoint in path_points.get_children(): 
		path_point.visible = visible
	visual_curve.visible = visible

# Called from the info box
func delete():
	queue_free()
	
	# queue_free haven't taken effect yet.
	# Do this so the note works as if this event is gone when receiving the signal.
	get_parent().remove_child(self)
	
	on_event_updated.emit(self)

func on_viewport_size_changed():
	redraw_curve()

### CHANGE (SET) CHECKPOINTS ### Called from the UI
func change_start_checkpoint(checkpoint: NoteCheckpoint):
	disconnect_start_checkpoint()
	start_checkpoint = checkpoint
	if is_instance_valid(checkpoint):
		connect_start_checkpoint()
		on_start_checkpoint_updated()

func change_destination_checkpoint(checkpoint: NoteCheckpoint):
	disconnect_destination_checkpoint()
	destination_checkpoint = checkpoint
	if is_instance_valid(checkpoint):
		connect_destination_checkpoint()
		on_destination_checkpoint_updated()

### CHECKPOINTS UPDATED ###
func on_destination_checkpoint_updated():
	# Update the last point of the path
	path.set_point_position(path.point_count - 1, destination_checkpoint.play_position)
	redraw_curve()
	on_event_updated.emit(self)

func on_start_checkpoint_updated():
	# Update the first point of the path
	path.set_point_position(0, start_checkpoint.play_position)
	redraw_curve()
	on_event_updated.emit(self)

### CHECKPOINTS RENAMED ###
func on_checkpoints_renamed():
	on_event_ui_needs_update.emit()

### CHECKPOINTS DELETED ###
func on_start_checkpoint_deleted(_c):
	change_start_checkpoint(null)
	on_event_ui_needs_update.emit()

func on_destination_checkpoint_deleted(_c):
	change_destination_checkpoint(null)
	on_event_ui_needs_update.emit()

### PATH POINTS UPDATED ###
# Called from path points
func load_info_from_path_point(path_point: PathPoint):
	path.set_point_position(path_point.index, path_point.play_position)
	path.set_point_in(path_point.index, path_point.in_point.play_position)
	path.set_point_out(path_point.index, path_point.out_point.play_position)
	redraw_curve()
	on_event_updated.emit(self)

### ADD / REMOVE CURVE POINT ###
### ASSUMING THE MOVE EVENT IS CURRENTLY SELECTED ###
func remove_curve_point(index: int):
	# Remove the actual point
	path.remove_point(index)
	redraw_curve()
	
	# Respawn all path points + re-initialize the curve editor
	# because the indices of the old path points will be messed up.
	spawn_path_points()
	SignalManager.on_move_event_selected.emit(self)
	
	on_event_updated.emit(self)

func add_curve_point():
	# Add the actual point
	# @ the position halfway between the last and the second to last point
	var new_position = path.sample(path.point_count - 2, 0.5)
	path.add_point(new_position, Vector2.ZERO, Vector2.ZERO, path.point_count - 1)
	redraw_curve()
	
	# Show one new path point
	var path_point: PathPoint = add_path_point(path.point_count - 2)
	
	# Tell the curve editor to add a new info box
	var info_box: PathPointInfoBox = path_point.get_and_initialize_info_box()
	SignalManager.on_path_point_info_box_added.emit(info_box)
	
	on_event_updated.emit(self)

### ESSENTIALS ###
func redraw_curve():
	visual_curve.clear_points()
	for point in path.get_baked_points():  
		visual_curve.add_point(PlayAreaUtils.get_world_position(point))

func spawn_path_points():
	GodotUtils.delete_all_children(path_points)
	for i in range(1, path.point_count - 1): add_path_point(i)
		
func add_path_point(index: int) -> PathPoint:
	var path_point: PathPoint = ScenePreloader.path_point.instantiate()
	path_point.initialize(self, index)
	path_points.add_child(path_point)
	return path_point

func despawn_path_points():
	GodotUtils.delete_all_children(path_points)

func get_path_point_info_boxes() -> Array:
	var info_boxes = Array()
	for path_point: PathPoint in path_points.get_children():
		info_boxes.append(path_point.get_and_initialize_info_box())
	
	return info_boxes

func connect_start_checkpoint():
	if is_instance_valid(start_checkpoint):
		start_checkpoint.on_checkpoint_updated.connect(on_start_checkpoint_updated)
		start_checkpoint.on_checkpoint_renamed.connect(on_checkpoints_renamed)
		start_checkpoint.on_checkpoint_deleted.connect(on_start_checkpoint_deleted)

func connect_destination_checkpoint():
	if is_instance_valid(destination_checkpoint):
		destination_checkpoint.on_checkpoint_updated.connect(on_destination_checkpoint_updated)
		destination_checkpoint.on_checkpoint_renamed.connect(on_checkpoints_renamed)
		destination_checkpoint.on_checkpoint_deleted.connect(on_destination_checkpoint_deleted)
	
func disconnect_start_checkpoint():
	if is_instance_valid(start_checkpoint):
		start_checkpoint.on_checkpoint_updated.disconnect(on_start_checkpoint_updated)
		start_checkpoint.on_checkpoint_renamed.disconnect(on_checkpoints_renamed)
		
func disconnect_destination_checkpoint():
	if is_instance_valid(destination_checkpoint):
		destination_checkpoint.on_checkpoint_updated.disconnect(on_destination_checkpoint_updated)
		destination_checkpoint.on_checkpoint_renamed.disconnect(on_checkpoints_renamed)
	


	


