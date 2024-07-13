extends PlayAreaObject

class_name NoteBody

@export var mouse_follower: MouseFollower
@export var note: Note

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_follower.on_cancelled.connect(on_creation_cancelled)
	mouse_follower.on_confirmed.connect(on_creation_confirmed)
	mouse_follower.on_zone_entered.connect(on_creation_zone_entered)
	mouse_follower.on_zone_exited.connect(on_creation_zone_exited)
	mouse_follower.on_moved.connect(waiting_move_by)
	
	go_regular_mode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Called from mouse follower.
func waiting_move_by(amount: Vector2) -> void:
	set_world_position(position + amount)
	var delta_play_position = PlayAreaUtils.get_delta_play_position(amount)
	note.move_by(Vector2(delta_play_position.x, 0)) # Move the note by the same amount horizontally

# Creation mode: following the cursor, waiting to be added to the note
func go_creation_mode():
	mouse_follower.process_mode = Node.PROCESS_MODE_INHERIT

# Regular mode: editor, ready to be dragged
func go_regular_mode():
	mouse_follower.process_mode = Node.PROCESS_MODE_DISABLED

func on_creation_confirmed():
	note.on_creation_confirmed()

func on_creation_cancelled():
	note.on_creation_cancelled()

func on_creation_zone_exited():
	note.on_creation_zone_exited()

func on_creation_zone_entered():
	note.on_creation_zone_entered()
