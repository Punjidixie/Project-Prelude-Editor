extends PlayAreaObject

class_name NoteCheckpoint

# To tell the info box to update
# Why does this have to exist?
# Because info box needs a different signal. 
# When load_info_from_info_box is called from the info box, that other signal emitted.
# I don't want the info box to receive that signal because the checkpoint was already updated from the info box itself...
signal on_checkpoint_ui_needs_update() 

# For general purposes ; synchonizing other nodes
signal on_checkpoint_updated() 

# Local time
@export var target_time : float
@export var checkpoint_name : String
@export var click_area : Area2D

var draggable = false
var drag_position : Vector2

func _ready():
	super._ready()
	click_area.mouse_entered.connect(on_mouse_entered)
	click_area.mouse_exited.connect(on_mouse_exited)

func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("left_click"):
			drag_position = get_local_mouse_position()
		elif Input.is_action_pressed("left_click"):
			set_world_position(get_global_mouse_position())
			on_checkpoint_updated.emit()
			on_checkpoint_ui_needs_update.emit()
			
		
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

func on_mouse_entered():
	draggable = true

func on_mouse_exited():
	draggable = false


