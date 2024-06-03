extends NoteEvent

class_name EndEvent

@export var end_checkpoint : NoteCheckpoint

func _ready():
	start_time = end_checkpoint.target_time
	end_checkpoint.on_checkpoint_updated.connect(on_end_checkpoint_updated)

func get_notebody_play_position(local_time: float):
	return end_checkpoint.play_position

func get_and_initialize_info_box():
	var info_box : EndEventInfoBox = ScenePreloader.end_event_info_box.instantiate()
	info_box.initialize(self)
	return info_box

func load_info_from_info_box(info_box: EventInfoBox):
	var end_info_box := info_box as EndEventInfoBox
	start_time = float(end_info_box.time_label.text)
	on_event_updated.emit()

func on_end_checkpoint_updated():
	start_time = end_checkpoint.target_time
	on_event_updated.emit()
	on_event_ui_needs_update.emit()
