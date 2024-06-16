extends PlayAreaObject

class_name NoteCheckpoint

# To tell the info box to update
# Why does this have to exist?
# Because info box needs a different signal. 
# When load_info_from_info_box is called from the info box, that other signal emitted.
# I don't want the info box to receive that signal because the checkpoint was already updated from the info box itself...
signal on_checkpoint_ui_needs_update() 

# For general purposes ; synchonizing other nodes. Update events and its note.
signal on_checkpoint_updated(c: NoteCheckpoint)

signal on_checkpoint_clicked()

# Local time
@export var target_time : float
@export var checkpoint_name : String
@export var click_area : Control

var following_mouse = false
var mouse_in = false # to be able to start following mouse
var drag_position : Vector2

func _ready():
	super._ready()
	click_area.mouse_entered.connect(on_mouse_entered)
	click_area.mouse_exited.connect(on_mouse_exited)

func _process(delta):
	if mouse_in:
		if Input.is_action_just_pressed("left_click"):
			drag_position = get_local_mouse_position()
			following_mouse = true
			on_checkpoint_clicked.emit()

	if following_mouse:
		follow_mouse()
		if Input.is_action_just_released("left_click"):
			following_mouse = false
			
		
func get_and_initialize_info_box() -> CheckpointInfoBox:
	var info_box = ScenePreloader.checkpoint_info_box.instantiate()
	info_box.initialize(self)
	return info_box

# Change 1 : Called from info box when it changes
func load_info_from_info_box(info_box : CheckpointInfoBox) -> void:
	var new_play_position = Vector2(float(info_box.x_input_box.text), float(info_box.y_input_box.text))
	set_play_position(new_play_position)
	
	target_time = float(info_box.time_input_box.text)
	on_checkpoint_updated.emit(self)

# Change 2 : Called from being dragged from its sprite
func follow_mouse():
	var new_world_position = get_global_mouse_position() - drag_position
	var new_play_position = PlayAreaUtils.get_play_position(new_world_position)
	if GlobalManager.move_all == true:
		# Tell the note to move everything
		SignalManager.move_all_by.emit(new_play_position - play_position)
	else:
		# Move itself and tell related events
		set_world_position(new_world_position)
		on_checkpoint_updated.emit(self)
		
	on_checkpoint_ui_needs_update.emit()
	
# Change 3 : Called from note when note UI changes (only end checkpoints)
func load_time_from_note(new_time: float) -> void:
	target_time = new_time
	on_checkpoint_updated.emit(self)
	on_checkpoint_ui_needs_update.emit()

# Change 4: Called from note when another checkpoint changes (and move_all is active)
func move_by(delta_position: Vector2) -> void:
	set_play_position(play_position + delta_position)
	
	# No need to emit checkpoint_updated. Connected events will move by the same amount. 
	on_checkpoint_ui_needs_update.emit()
	
func on_mouse_entered():
	mouse_in = true
	
func on_mouse_exited():
	mouse_in = false


