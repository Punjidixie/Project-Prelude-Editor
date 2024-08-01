extends NoteEvent

class_name EndEvent

@export var end_checkpoint: NoteCheckpoint
@export var end_speed: float

func _ready():
	start_time = end_checkpoint.target_time
	end_checkpoint.on_checkpoint_updated.connect(on_end_checkpoint_updated)

func get_notebody_play_position(local_time: float):
	if GlobalManager.is_auto_play:
		return end_checkpoint.play_position
	
	var time_diff = local_time - start_time
	return end_checkpoint.play_position - Vector2(0, end_speed * time_diff)

func get_and_initialize_info_box():
	var info_box : EndEventInfoBox = ScenePreloader.end_event_info_box.instantiate()
	info_box.initialize(self)
	return info_box

func load_info_from_info_box(info_box: EventInfoBox):
	var end_info_box := info_box as EndEventInfoBox
	#start_time = float(end_info_box.time_label.text)
	end_speed = float(end_info_box.end_speed_input_box.text)
	on_event_updated.emit(self)

func scale_time_by(factor: float):
	start_time *= factor
	end_speed /= factor
	on_event_ui_needs_update.emit()
	#on_event_updated.emit() # No need. Update will eventually be called.

func on_end_checkpoint_updated():
	start_time = end_checkpoint.target_time
	on_event_updated.emit(self)
	on_event_ui_needs_update.emit() 

func get_ending_lifetime():
	return (-GridUtils.get_lower_left_border().y) / end_speed
