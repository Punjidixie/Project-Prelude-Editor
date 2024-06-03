extends PlayAreaObject

class_name NoteCheckpoint

# To tell the info box to update
# Why does this have to exist?
# Because info box needs a different signal. 
# When load_info_from_info_box is called from the info box, that other signal emitted.
# I don't want the info box to receive that signal because the checkpoint was already updated from the info box itself...
signal on_checkpoint_dragged() 

# For general purposes ; synchonizing other nodes
signal on_checkpoint_updated() 

# Local time
@export var target_time : float
@export var checkpoint_name : String

func get_and_initialize_info_box() -> CheckpointInfoBox:
	var info_box = ScenePreloader.checkpoint_info_box.instantiate()
	info_box.initialize(self)
	return info_box

# Called from info box when it changes
func load_info_from_info_box(info_box : CheckpointInfoBox) -> void:
	var new_play_position = Vector2(float(info_box.x_input_box.text), float(info_box.y_input_box.text))
	set_play_position(new_play_position)
	
	target_time = float(info_box.time_input_box.text)
	on_checkpoint_updated.emit()



