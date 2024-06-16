extends NoteEvent

class_name AppearEvent

@export var start_checkpoint : NoteCheckpoint

func _ready():
	start_time = start_checkpoint.target_time
	start_checkpoint.on_checkpoint_updated.connect(on_start_checkpoint_updated)

func get_notebody_play_position(local_time: float):
	return start_checkpoint.play_position

func get_and_initialize_info_box():
	var info_box : AppearEventInfoBox = ScenePreloader.appear_event_info_box.instantiate()
	info_box.initialize(self)
	return info_box

func load_info_from_info_box(info_box: EventInfoBox):
	var appear_info_box := info_box as AppearEventInfoBox
	start_time = float(appear_info_box.time_label.text)
	on_event_updated.emit(self)

func on_start_checkpoint_updated():
	start_time = start_checkpoint.target_time
	on_event_updated.emit(self)
	on_event_ui_needs_update.emit()


	
	
