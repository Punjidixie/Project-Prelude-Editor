extends PlayAreaObject

class_name NoteCheckpoint

# To tell the info box to update
# Why does this have to exist?
# Because info box needs a different signal. 
# When load_info_from_info_box is called from the info box, that other signal emitted.
# I don't want the info box to receive that signal because the checkpoint was already updated from the info box itself...
signal on_checkpoint_ui_needs_update() 

# For general purposes ; synchonizing other nodes. Update events and its note.
signal on_checkpoint_updated()

signal on_checkpoint_clicked()

signal on_checkpoint_renamed()

# Local time
@export var target_time : float
@export var checkpoint_name : String
@export var drag_detector: DragDetector
@export var mouse_follower: MouseFollower

var following_mouse = false
var mouse_in = false # to be able to start following mouse
var drag_position : Vector2

var note: Note

func _ready():
	super._ready()
	drag_detector.on_dragged.connect(on_dragged)
	drag_detector.on_clicked.connect(on_clicked)
	
	mouse_follower.on_cancelled.connect(on_creation_cancelled)
	mouse_follower.on_confirmed.connect(on_creation_confirmed)
	mouse_follower.on_moved.connect(waiting_move_by)
	
	go_regular_mode()

# Creation mode: following the cursor, waiting to be added to the note
func go_creation_mode():
	drag_detector.process_mode = Node.PROCESS_MODE_DISABLED
	mouse_follower.process_mode = Node.PROCESS_MODE_INHERIT

# Regular mode: editor, ready to be dragged
func go_regular_mode():
	drag_detector.process_mode = Node.PROCESS_MODE_INHERIT
	mouse_follower.process_mode = Node.PROCESS_MODE_DISABLED
			
		
func get_and_initialize_info_box() -> CheckpointInfoBox:
	var info_box = ScenePreloader.checkpoint_info_box.instantiate()
	info_box.initialize(self)
	return info_box

# Change 1 : Called from info box when it changes
func load_info_from_info_box(info_box : CheckpointInfoBox) -> void:
	var new_play_position = Vector2(float(info_box.x_input_box.text), float(info_box.y_input_box.text))
	var delta_play_position = new_play_position - play_position
	target_time = float(info_box.time_input_box.text)
	
	# Dealing with position
	if GlobalManager.move_all == true:
		# Move everything
		note.move_all(delta_play_position) 
	else:
		# Move self
		set_play_position(play_position + delta_play_position)
			

	note.name_all_checkpoints() # Because the time order might have changed.
	on_checkpoint_updated.emit() # In any case, time might have changed.

# Change 2 : Called from being dragged from its sprite
func on_dragged(amount: Vector2):
	var delta_play_position = PlayAreaUtils.get_delta_play_position(amount)
	if GlobalManager.move_all == true:
		# Move everything
		note.move_all(delta_play_position) 
	else:
		# Move self and tell related events
		set_play_position(play_position + delta_play_position)
		on_checkpoint_updated.emit()
		on_checkpoint_ui_needs_update.emit()
		
# Called from note.move_all() when another checkpoint changes (and move_all is active)
func move_by(delta_position: Vector2) -> void:
	set_play_position(play_position + delta_position)
	# No need to emit checkpoint_updated. 
	# Only the position changes, connected events will move by the same amount. 
	on_checkpoint_ui_needs_update.emit()
	
# Change 3 : Called from note when note's top UI changes (only end checkpoints)
func load_time_from_note(new_time: float) -> void:
	target_time = new_time
	on_checkpoint_updated.emit()
	on_checkpoint_ui_needs_update.emit()

# Change 4: Called from mouse follower.
func waiting_move_by(amount: Vector2) -> void:
	set_world_position(position + amount)

func rename(new_name: String) -> void:
	checkpoint_name = new_name
	on_checkpoint_renamed.emit() # UI needs to know about the name change.

# Connected to the drag detector
func on_clicked():
	note.on_checkpoint_clicked()

func on_creation_confirmed():
	note.add_checkpoint(self)
	go_regular_mode()

func on_creation_cancelled():
	queue_free()
