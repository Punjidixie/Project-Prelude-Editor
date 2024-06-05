extends NoteEvent


class_name MoveEvent

@export var path : Curve2D
@export var start_checkpoint : NoteCheckpoint
@export var destination_checkpoint : NoteCheckpoint

@export var visual_curve : Line2D

func _ready():
	get_tree().get_root().size_changed.connect(on_viewport_size_changed)
	connect_start_checkpoint()
	connect_destination_checkpoint()

# get the current note's play position from local time
func get_notebody_play_position(local_time: float):
	var current_path_time = local_time - start_time
	var total_path_time = destination_checkpoint.target_time - start_time
	var progress_ratio = current_path_time / total_path_time
	return path.sample_baked(path.get_baked_length() * progress_ratio)

func get_and_initialize_info_box():
	var info_box : EventInfoBox = ScenePreloader.move_event_info_box.instantiate()
	info_box.initialize(self)
	return info_box

# Called from info box when it changes
func load_info_from_info_box(info_box: EventInfoBox):
	var move_event_box := info_box as MoveEventInfoBox
	start_time = float(move_event_box.time_input_box.text)
	on_event_updated.emit()

func redraw_curve():
	visual_curve.clear_points()
	visual_curve.default_color = Color(1,1,1,0.5)  
	visual_curve.width = 1.5
	for point in path.get_baked_points():  
		visual_curve.add_point(PlayAreaUtils.get_world_position(point))
	on_event_updated.emit()
		
func on_viewport_size_changed():
	redraw_curve()

func on_destination_checkpoint_updated():
	# Update the last point of the path
	path.set_point_position(path.point_count - 1, destination_checkpoint.play_position)
	redraw_curve()

func on_start_checkpoint_updated():
	# Update the first point of the path
	path.set_point_position(0, start_checkpoint.play_position)
	redraw_curve()

func connect_start_checkpoint():
	start_checkpoint.on_checkpoint_updated.connect(on_start_checkpoint_updated)

func connect_destination_checkpoint():
	destination_checkpoint.on_checkpoint_updated.connect(on_destination_checkpoint_updated)
	
func disconnect_start_checkpoint():
	start_checkpoint.on_checkpoint_updated.disconnect(on_start_checkpoint_updated)

func disconnect_destination_checkpoint():
	destination_checkpoint.on_checkpoint_updated.disconnect(on_destination_checkpoint_updated)


	


